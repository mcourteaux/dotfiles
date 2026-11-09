-- Halide Stmt: brace-based folding and background shading of
-- gpu_block (yellow, stronger inside gpu_thread) and parallel (blue) scopes,
-- plus rainbow delimiters (and the operators inside parentheses/brackets).

local ns = vim.api.nvim_create_namespace('halide_scopes')
local ns_rainbow = vim.api.nvim_create_namespace('halide_rainbow')

-- Mix `amount` of color `b` into color `a` (both 0xRRGGBB).
local function blend(a, b, amount)
  local r = 0
  for shift = 16, 0, -8 do
    local ca = bit.band(bit.rshift(a, shift), 0xff)
    local cb = bit.band(bit.rshift(b, shift), 0xff)
    r = bit.bor(r, bit.lshift(math.floor(ca + (cb - ca) * amount + 0.5), shift))
  end
  return r
end

-- Terminal background as reported by OSC 11 (used when the colorscheme is
-- transparent, i.e. Normal has no bg).
local term_bg = nil

local function define_highlights()
  local bg = vim.api.nvim_get_hl(0, { name = 'Normal', link = false }).bg or term_bg
  if not bg then
    bg = vim.o.background == 'light' and 0xffffff or 0x1c1c1c
  end
  vim.api.nvim_set_hl(0, 'HalideGpuBlockScope', { bg = blend(bg, 0xffcc00, 0.07) })
  vim.api.nvim_set_hl(0, 'HalideGpuThreadScope', { bg = blend(bg, 0xffcc00, 0.13) })
  vim.api.nvim_set_hl(0, 'HalideParallelScope', { bg = blend(bg, 0x3388ff, 0.09) })
  -- Left border bar (fg) on top of the scope's own shading (bg).
  vim.api.nvim_set_hl(0, 'HalideGpuBlockScopeBorder',
    { fg = blend(bg, 0xffcc00, 0.25), bg = blend(bg, 0xffcc00, 0.07) })
  vim.api.nvim_set_hl(0, 'HalideGpuThreadScopeBorder',
    { fg = blend(bg, 0xffcc00, 0.38), bg = blend(bg, 0xffcc00, 0.13) })
  vim.api.nvim_set_hl(0, 'HalideParallelScopeBorder',
    { fg = blend(bg, 0x3388ff, 0.30), bg = blend(bg, 0x3388ff, 0.09) })

  local light = vim.o.background == 'light'
  vim.api.nvim_set_hl(0, 'halideGpuLoop', { fg = light and 0x9a6700 or 0xe3b341, bold = true })
  vim.api.nvim_set_hl(0, 'halideParallelLoop', { fg = light and 0x0969da or 0x58a6ff, bold = true })
  vim.api.nvim_set_hl(0, 'halideThreadIdX', { fg = light and 0xcf222e or 0xff6b6b, bold = true })
  vim.api.nvim_set_hl(0, 'halideThreadIdY', { fg = light and 0x1a7f37 or 0x7ee787, bold = true })
  vim.api.nvim_set_hl(0, 'halideThreadIdZ', { fg = light and 0x8250df or 0x6cb6ff, bold = true })
end

local function query_term_bg()
  if #vim.api.nvim_list_uis() == 0 then return end
  vim.api.nvim_create_autocmd('TermResponse', {
    callback = function(ev)
      local seq = ev.data and ev.data.sequence or vim.v.termresponse
      local r, g, b = seq:match('^\27%]11;rgb:(%x+)/(%x+)/(%x+)')
      if not r then return end -- not ours, keep listening
      local function c(h) return math.floor(tonumber(h, 16) / (16 ^ #h - 1) * 255 + 0.5) end
      term_bg = c(r) * 0x10000 + c(g) * 0x100 + c(b)
      define_highlights()
      return true
    end,
  })
  io.stdout:write('\27]11;?\27\\')
end

-- Global setup (only once).
if not vim.g.halide_scope_hl_setup then
  vim.g.halide_scope_hl_setup = true
  define_highlights()
  query_term_bg()
  vim.api.nvim_create_autocmd({ 'ColorScheme', 'OptionSet' }, {
    pattern = { '*', 'background' },
    callback = function(ev)
      if ev.event == 'OptionSet' and ev.match ~= 'background' then return end
      define_highlights()
      if ev.event == 'ColorScheme' then query_term_bg() end
    end,
  })
end

local border_char = '▌'

local scope_hl = {
  gpu_block = 'HalideGpuBlockScope',
  gpu_thread = 'HalideGpuThreadScope',
  parallel = 'HalideParallelScope',
}

-- Per-buffer cache: { tick = changedtick, levels = { [lnum] = foldexpr value },
--   braces/parens = { [lnum] = nesting depth at line start } }
local cache = {}

-- Call fn(col, ch) for every character outside strings and // comments.
local function scan(line, fn)
  local i, n, in_str = 1, #line, false
  while i <= n do
    local ch = line:sub(i, i)
    if in_str then
      if ch == '\\' then i = i + 1 elseif ch == '"' then in_str = false end
    elseif ch == '"' then
      in_str = true
    elseif ch == '/' and line:sub(i + 1, i + 1) == '/' then
      return
    else
      fn(i, ch)
    end
    i = i + 1
  end
end

local function analyze(buf)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local c = cache[buf]
  if c and c.tick == tick then return c end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local levels, braces, parens = {}, {}, {}
  local pdepth = 0
  local stack = {} -- per open brace: { kind, indent } for shaded scopes, else false

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for lnum, line in ipairs(lines) do
    local depth_start = #stack
    local opened, closed = false, false
    braces[lnum], parens[lnum] = depth_start, pdepth

    -- Shaded scopes this line belongs to: those open at its start, plus the
    -- ones it opens (so headers and closing braces are shaded too).
    local shaded = {}
    for _, e in ipairs(stack) do
      if e then shaded[#shaded + 1] = e end
    end

    local indent, kind = line:match('^(%s*)(%a[%w_]*)')
    if kind ~= 'gpu_block' and kind ~= 'gpu_thread' and kind ~= 'parallel' then
      kind = nil
    end
    local opener = kind and { kind = kind, indent = #indent } or false

    scan(line, function(_, ch)
      if ch == '{' then
        stack[#stack + 1] = opener
        if opener then shaded[#shaded + 1] = opener end
        opener = false -- only the first brace on the line opens the scope
        opened = true
      elseif ch == '}' then
        if #stack > 0 then stack[#stack] = nil end
        closed = true
      elseif ch == '(' or ch == '[' then
        pdepth = pdepth + 1
      elseif (ch == ')' or ch == ']') and pdepth > 0 then
        pdepth = pdepth - 1
      end
    end)
    local n = #line

    if opened then
      levels[lnum] = '>' .. #stack
    elseif closed then
      levels[lnum] = '<' .. depth_start
    else
      levels[lnum] = depth_start
    end

    -- Shade from each scope's indent to the window edge; inner scopes on top.
    for depth, e in ipairs(shaded) do
      local hl, border = scope_hl[e.kind], scope_hl[e.kind] .. 'Border'
      if e.indent < n then
        vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, e.indent, {
          end_row = lnum,
          end_col = 0,
          hl_group = hl,
          hl_eol = true,
          priority = 10 + 2 * depth,
          strict = false,
        })
        -- Bar only over whitespace, so the header and closing brace stay readable.
        if line:sub(e.indent + 1, e.indent + 1):match('%s') then
          vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, e.indent, {
            virt_text = { { border_char, border } },
            virt_text_pos = 'overlay',
            priority = 11 + 2 * depth,
          })
        end
      else -- line too short (e.g. blank): paint past its end
        vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
          virt_text = { { border_char, border }, { string.rep(' ', 1000), hl } },
          virt_text_win_col = e.indent,
          priority = 10 + 2 * depth,
        })
      end
    end
  end

  c = { tick = tick, levels = levels, braces = braces, parens = parens }
  cache[buf] = c
  return c
end

-- Rainbow delimiters: braces cycle by scope depth, parentheses/brackets (and
-- the operators directly inside them) by expression depth. Drawn per visible
-- line with ephemeral extmarks, so huge stmt files stay fast.
local rainbow = {
  'RainbowDelimiterRed', 'RainbowDelimiterYellow', 'RainbowDelimiterBlue',
  'RainbowDelimiterOrange', 'RainbowDelimiterGreen', 'RainbowDelimiterViolet',
  'RainbowDelimiterCyan',
}
local operators = {}
for ch in ('+-*/%<>=!&|^~'):gmatch('.') do operators[ch] = true end

local function paint(buf, row, col, depth)
  vim.api.nvim_buf_set_extmark(buf, ns_rainbow, row, col - 1, {
    end_col = col,
    hl_group = rainbow[(depth - 1) % #rainbow + 1],
    priority = 150,
    ephemeral = true,
  })
end

vim.api.nvim_set_decoration_provider(ns_rainbow, {
  on_win = function(_, _, buf)
    if vim.bo[buf].filetype ~= 'halide' then return false end
    local c = cache[buf]
    if c and c.tick == vim.api.nvim_buf_get_changedtick(buf) then return true end
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(buf) then
        analyze(buf)
        vim.cmd.redraw({ bang = true })
      end
    end)
    return false
  end,
  on_line = function(_, _, buf, row)
    local c = cache[buf]
    local bdepth, pdepth = c.braces[row + 1], c.parens[row + 1]
    if not bdepth then return end
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
    scan(line, function(col, ch)
      if ch == '{' then
        bdepth = bdepth + 1
        paint(buf, row, col, bdepth)
      elseif ch == '}' then
        if bdepth > 0 then paint(buf, row, col, bdepth); bdepth = bdepth - 1 end
      elseif ch == '(' or ch == '[' then
        pdepth = pdepth + 1
        paint(buf, row, col, pdepth)
      elseif ch == ')' or ch == ']' then
        if pdepth > 0 then paint(buf, row, col, pdepth); pdepth = pdepth - 1 end
      elseif operators[ch] and pdepth > 0 then
        paint(buf, row, col, pdepth)
      end
    end)
  end,
})

_G.HalideFoldExpr = function(lnum)
  return analyze(vim.api.nvim_get_current_buf()).levels[lnum] or 0
end

local buf = vim.api.nvim_get_current_buf()

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.HalideFoldExpr(v:lnum)'
vim.wo.foldlevel = 99

analyze(buf)

local group = vim.api.nvim_create_augroup('halide_scopes_' .. buf, { clear = true })
vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'BufReadPost' }, {
  group = group,
  buffer = buf,
  callback = function() analyze(buf) end,
})
vim.api.nvim_create_autocmd({ 'BufWipeout' }, {
  group = group,
  buffer = buf,
  callback = function() cache[buf] = nil end,
})

local undo = vim.b.undo_ftplugin
vim.b.undo_ftplugin = (undo and undo ~= '' and undo .. ' | ' or '')
  .. 'setlocal foldmethod< foldexpr< foldlevel<'
  .. ' | lua vim.api.nvim_buf_clear_namespace(0, ' .. ns .. ', 0, -1)'
