-- Halide Stmt: brace-based folding and background shading of
-- gpu_block (yellow, stronger inside gpu_thread) and parallel (blue) scopes.

local ns = vim.api.nvim_create_namespace('halide_scopes')

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
  vim.api.nvim_set_hl(0, 'HalideGpuBlockScope', { bg = blend(bg, 0xffcc00, 0.12) })
  vim.api.nvim_set_hl(0, 'HalideGpuThreadScope', { bg = blend(bg, 0xffcc00, 0.22) })
  vim.api.nvim_set_hl(0, 'HalideParallelScope', { bg = blend(bg, 0x3388ff, 0.15) })

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

local scope_hl = {
  gpu_block = 'HalideGpuBlockScope',
  gpu_thread = 'HalideGpuThreadScope',
  parallel = 'HalideParallelScope',
}

-- Per-buffer cache: { tick = changedtick, levels = { [lnum] = foldexpr value } }
local cache = {}

local function analyze(buf)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local c = cache[buf]
  if c and c.tick == tick then return c end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local levels = {}
  local stack = {} -- per open brace: { kind, indent } for shaded scopes, else false

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for lnum, line in ipairs(lines) do
    local depth_start = #stack
    local opened, closed = false, false

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

    local i, n, in_str = 1, #line, false
    while i <= n do
      local ch = line:sub(i, i)
      if in_str then
        if ch == '\\' then i = i + 1 elseif ch == '"' then in_str = false end
      elseif ch == '"' then
        in_str = true
      elseif ch == '/' and line:sub(i + 1, i + 1) == '/' then
        break
      elseif ch == '{' then
        stack[#stack + 1] = opener
        if opener then shaded[#shaded + 1] = opener end
        opener = false -- only the first brace on the line opens the scope
        opened = true
      elseif ch == '}' then
        if #stack > 0 then stack[#stack] = nil end
        closed = true
      end
      i = i + 1
    end

    if opened then
      levels[lnum] = '>' .. #stack
    elseif closed then
      levels[lnum] = '<' .. depth_start
    else
      levels[lnum] = depth_start
    end

    -- Shade from each scope's indent to the window edge; inner scopes on top.
    for depth, e in ipairs(shaded) do
      if e.indent < n then
        vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, e.indent, {
          end_row = lnum,
          end_col = 0,
          hl_group = scope_hl[e.kind],
          hl_eol = true,
          priority = 10 + depth,
          strict = false,
        })
      else -- line too short (e.g. blank): paint past its end
        vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
          virt_text = { { string.rep(' ', 1000), scope_hl[e.kind] } },
          virt_text_win_col = e.indent,
          priority = 10 + depth,
        })
      end
    end
  end

  c = { tick = tick, levels = levels }
  cache[buf] = c
  return c
end

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
