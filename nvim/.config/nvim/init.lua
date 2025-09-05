-- nvim-tree: disable netrw at the very start of your init.lua
--vim.g.loaded_netrw = 1
--vim.g.loaded_netrwPlugin = 1
--vim: shiftwidth=2 expandtab


vim.o.encoding = "UTF-8"
vim.o.swapfile = false
vim.g.mapleader = ","
vim.g.maplocalleader = "_"

vim.o.wildmode = "longest,full"


-- Enable Python 3 support
-- Disable python2 support
vim.g.loaded_python_provider = 0
vim.g.python3_host_prog = '/usr/bin/python3'
vim.o.pyxversion = 3


-- Lazy is the recommended NVim package manager.
-- This snippet bootstraps it in case it does not exist yet!
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- Load OpenAI key for plugins
local openai_key_found = false
if false then
  --local openai_api_key = vim.fn.join(vim.fn.readfile(vim.fn.expand("~/.config/vim-chatgpt.key")))
  local openai_api_key_file = io.open(os.getenv("HOME") .. "/.config/vim-chatgpt.key", "r")
  if not openai_api_key_file then
      print("Failed to open the OpenAI API key file: ~/.config/vim-chatgpt.key")
  else
      local openai_api_key = openai_api_key_file:read("*all")
      openai_api_key = string.gsub(openai_api_key, "\n$", "") -- Strip trailing newline
      openai_api_key_file:close()
      vim.g.openai_api_key = openai_api_key
      openai_key_found = true
  end
end

-- Utility function to find the git project root
find_git_root = function()
  local gitRoot = vim.fn.system('git rev-parse --show-toplevel 2> /dev/null'):sub(1,-2)
  if gitRoot == '' then
    gitRoot = vim.fn.getcwd()
  end
  return gitRoot
end


-- Actually load lazy.nvim
require("lazy").setup({
  { 'andymass/vim-matchup' },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require("nvim-treesitter").install({ 'cpp', 'html', 'css', 'zig', 'cmake', 'bash' })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { "lua", "html", "css", "js" },
        -- Do not specify a `pattern`, because we want to auto-enable `treesitter` for all files.
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'HiPhish/rainbow-delimiters.nvim',
    lazy = false,
    main = 'rainbow-delimiters.setup',
    opts = {},
  },
  {
    "ficcdaf/academic.nvim",
    -- recommended: rebuild on plugin update
    build = ":AcademicBuild",
    --config = function()
    --  local aca = require('academic')
    --  print("config", aca)
    --  aca.setup({})
    --end
  },
  { 'nvim-focus/focus.nvim', version = false },


  -- LSP
  { 'neovim/nvim-lspconfig' },
  {
    -- Signature hints when moving cursor through arguments.
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
  { 'dcampos/nvim-snippy' },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      --'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          -- { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
      })

      -- Set up lspconfig.
      -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
      require('lspconfig')['ccls'].setup {
        capabilities = capabilities
      }

    end
  },
  {
     'SmiteshP/nvim-navic',
     dependencies = { 'neovim/nvim-lspconfig' },
     config = function()
       local navic = require('nvim-navic')
       navic.setup({
         highlight = true,
         lsp = {
           auto_attach = false,
           preference = nil,
         }
       })
     end
  },
  {
    "hedyhli/outline.nvim",
    config = function()
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
      { desc = "Toggle Outline" })

      require("outline").setup {
        -- Your setup opts here (leave empty to use defaults)
      }
    end,
  },

  -- Colorschemes
  { 'rktjmp/fwatch.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'Mofiqul/dracula.nvim' },
  { 'sainnhe/gruvbox-material' },
  { 'sainnhe/sonokai' },
  { 'sainnhe/everforest' },
  { 'sainnhe/edge' },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function()
      require('catppuccin').setup({
        transparent_background = true,
      })
    end,
  },
  { 'projekt0n/github-nvim-theme', name = 'github-theme',
    config = function()
      require('github-theme').setup({
        options = {
          transparent = true,
        },
      })
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
  {
    "airblade/vim-gitgutter",
    init = function()
      vim.g.gitgutter_highlight_linenrs = 1
    end,
    config = function()
      vim.o.number = true
      vim.api.nvim_set_hl(0, "GitGutterAddLineNr", { link = "GitGutterAdd" })
      vim.api.nvim_set_hl(0, "GitGutterChangeLineNr", { link = "GitGutterChange" })
      vim.api.nvim_set_hl(0, "GitGutterDeleteLineNr", { link = "GitGutterDelete" })
    end
  },

  -- FZF
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      local fzf = require("fzf-lua")
      fzf.setup({})

      -- Project Files
      vim.keymap.set('n', '<c-P>', function()
        fzf.files({ cmd = "fd", cwd = find_git_root() })
      end)
      -- Super Project Files
      vim.keymap.set('n', '<Leader><c-P>', function()
        --print(vim.fn.expand(find_git_root() .. '/../'))
        fzf.files({ cmd = "fd", cwd = vim.fn.expand(find_git_root() .. '/../') })
      end)
      -- Project Test Files
      vim.keymap.set('n', '<c-T>', function()
        fzf.files({ cmd = "fd", cwd = find_git_root() .. '/test/' })
      end)
      -- Project Lines
      vim.keymap.set('n', '<Leader>L', function()
        fzf.live_grep({ cmd = "rg", cwd = find_git_root() })
      end)
    end
  },

  -- NvimTree
  { 'nvim-tree/nvim-tree.lua' },
  { 'prichrd/netrw.nvim', config = function() require'netrw'.setup{} end },

  -- Various Tools
  { 'easymotion/vim-easymotion' },
  { 'editorconfig/editorconfig-vim' },
  { 'ntpeters/vim-better-whitespace' },
  { 'echasnovski/mini.align', version = false },
  { 'Konfekt/vim-sentence-chopper' },
  {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "gc", -- Default invocation prefix
      { "gc.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },

  -- Syntax Highlighting Plugins
  { 'beyondmarc/glsl.vim' },
  { 'rluba/jai.vim' },
  { 'kaarmu/typst.vim' },
  { 'rhysd/vim-llvm' },

  -- C++
  {
    'rhysd/vim-clang-format', config = function()
      --vim.api.nvim_set_keymap('n', '<Leader>cf', ':ClangFormat<CR>', { noremap = true, silent = true })
    end
  },
  {
    'derekwyatt/vim-fswitch',
    config = function()
      -- FSwitch (toggle source/header) mappings
      vim.api.nvim_set_keymap('n', '<Leader>a', ':FSHere<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>v', ':FSRight<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>V', ':FSSplitRight<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>s', ':FSBelow<CR>', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<Leader>S', ':FSSplitBelow<CR>', { noremap = true, silent = true })
    end
  },
  {
    -- C-style (Java / C++) argument objects for "cia" -> "change in argument"
    'AndrewRadev/sideways.vim',
    config = function()
      -- omap aa <Plug>SidewaysArgumentTextobjA
      vim.api.nvim_set_keymap('o', 'aa', '<Plug>SidewaysArgumentTextobjA', {})

      -- xmap aa <Plug>SidewaysArgumentTextobjA
      vim.api.nvim_set_keymap('x', 'aa', '<Plug>SidewaysArgumentTextobjA', {})

      -- omap ia <Plug>SidewaysArgumentTextobjI
      vim.api.nvim_set_keymap('o', 'ia', '<Plug>SidewaysArgumentTextobjI', {})

      -- xmap ia <Plug>SidewaysArgumentTextobjI
      vim.api.nvim_set_keymap('x', 'ia', '<Plug>SidewaysArgumentTextobjI', {})
    end
  },

  -- Python
  { 'tmhedberg/SimpylFold' },

  -- VimTex
  {
    'lervag/vimtex',
    dependencies = { 'andymass/vim-matchup' },
    config = function()
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_matchparen_deferred = 1

      vim.g.latex_flavor = 'latex'
      vim.g.vimtex_fold_enabled = 0
      vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_motion_enabled = 0
      vim.g.vimtex_syntax_conceal_disable = 1
      vim.g.vimtex_syntax_enabled = 0

      --vim.api.nvim_set_keymap('n', '<LocalLeader>lv', ':VimtexView<CR>', { noremap = true })
      if vim.fn.has('macunix') == 1 then
        vim.g.vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
        vim.g.vimtex_view_general_options = '-r @line @pdf @tex'
        vim.g.vimtex_fold_enabled = 0 -- So large files can open more easily
      elseif vim.fn.has('unix') == 1 then
        vim.g.vimtex_view_method = 'zathura'
      end


      function findLatexConfig()
        -- Get the current working directory
        local currentDir = vim.fn.getcwd()

        -- Iterate over each parent directory recursively until reaching the root
        while currentDir ~= '/' do
          local configFile = currentDir .. '/.latex_conf.nvim'

          -- Check if the config file exists
          if vim.fn.filereadable(configFile) == 1 then
            -- Read the first line of the file
            local file = io.open(configFile, 'r')
            local mainPdf = file:read('*line')
            file:close()

            vim.g.main_pdf = currentDir .. "/" .. mainPdf
            return
          end

          currentDir = vim.fn.fnamemodify(currentDir, ':h') -- Move up to the parent directory
        end
      end

      function Synctex()
        findLatexConfig()
        vim.cmd("silent !zathura --synctex-forward " .. vim.fn.line('.') .. ":" .. vim.fn.col('.') .. ":" .. vim.fn.expand('%:p')  .. " " .. vim.g.main_pdf)
        --vim.fn.system("zathura --synctex-forward " .. vim.fn.line('.') .. ":" .. vim.fn.col('.') .. ":" .. vim.fn.bufname('%') .. " " .. g:syncpdf)
        --
        local windowId = os.getenv("WINDOWID")
        local gdmSession = os.getenv("GDMSESSION")

        if windowId and gdmSession then
          -- Request focus using i3-msg
          if gdmSession == "i3" then
            vim.cmd("silent !i3-msg '[id=" .. windowId .. "]' focus")
          end
        else
          -- Not sure this is i3...
          print("Lost focus: i3 or WINDOWID not detected")
        end
      end
      vim.api.nvim_set_keymap('n', '<C-enter>', ':lua Synctex()<cr>', {silent = true})

    end
  },


  -- ChatGPT stuff
  (openai_key_found and {
    'CoderCookE/vim-chatgpt',
    config = function()
      -- Chat GPT
      vim.g.chat_gpt_max_tokens = 500
      -- vim.g.chat_gpt_model = 'gpt-4'
      vim.g.chat_gpt_model = 'gpt-3.5-turbo'
      vim.g.chat_gpt_session_mode = 0
      vim.g.chat_gpt_temperature = 0.2
      vim.g.chat_gpt_lang = 'English'
    end
  } or {}),

  -- Ollama
  {
      "David-Kunz/gen.nvim",
      opts = {
          model = "codegemma:7b", -- The default model to use.
          quit_map = "q", -- set keymap to close the response window
          retry_map = "<c-r>", -- set keymap to re-send the current prompt
          accept_map = "<c-cr>", -- set keymap to replace the previous selection with the last result
          host = "localhost", -- The host running the Ollama service.
          port = "11434", -- The port on which the Ollama service is listening.
          display_mode = "split", -- The display mode. Can be "float" or "split" or "horizontal-split".
          show_prompt = true, -- Shows the prompt submitted to Ollama. Can be true (3 lines) or "full".
          show_model = true, -- Displays which model you are using at the beginning of your chat session.
          no_auto_close = true, -- Never closes the window automatically.
          file = false, -- Write the payload to a temporary file to keep the command short.
          hidden = false, -- Hide the generation window (if true, will implicitly set `prompt.replace = true`), requires Neovim >= 0.10
          -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
          -- This can also be a command string.
          -- The executed command must return a JSON object with { response, context }
          -- (context property is optional).
          -- list_models = '<omitted lua function>', -- Retrieves a list of model names
          result_filetype = "markdown", -- Configure filetype of the result buffer
          debug = false -- Prints errors and the command which is run.
      }
  },
  -- Ollama code-completion
  --{
  --  'jacob411/Ollama-Copilot',
  --  opts = {
  --    model_name = "codegemma:2b",
  --    stream_suggestion = false,
  --    python_command = "python3",
  --    filetypes = {'python', 'lua', 'cpp', 'vim', "markdown"},
  --    ollama_model_opts = {
  --      num_predict = 40,
  --      temperature = 0.1,
  --    },
  --    keymaps = {
  --      suggestion = '<leader>os',
  --      reject = '<leader>or',
  --      insert_accept = '<Tab>',
  --    },
  --  }
  --},
})

vim.o.number = true
vim.o.autochdir = true
vim.o.showcmd = true
vim.o.hidden = true
vim.o.backspace = "indent,eol,start"

vim.o.splitbelow = true
vim.o.splitright = true

-- Indentation
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true

-- Highlight trailling whitespace
vim.o.listchars = "trail:·,tab:>-"

-- Folding tricks
vim.api.nvim_set_keymap('n', '<space>', 'za', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<space>', 'zf', { noremap = true, silent = true })

-- Uncomment the following lines if you wish to enable the "Over length marking" functionality
-- vim.cmd([[ autocmd FileType cpp,hpp,c,h highlight OverLength ctermbg=blue ]])
-- vim.cmd([[ autocmd FileType cpp,hpp,c,h match OverLength /\%81v.\+/ ]])


-- Also get the additional information to go into the diagnostics messages.
-- Taken from: https://github.com/neovim/neovim/issues/19649#issuecomment-1750272564
-- Stuff appearing twice in Trouble is because the additional information is added separately as
-- a Hint-diagnostic on the line number if one is found.
local original = vim.lsp.handlers['textDocument/publishDiagnostics']
vim.lsp.handlers['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
   vim.tbl_map(function(item)
      if item.relatedInformation and #item.relatedInformation > 0 then
         vim.tbl_map(function(k)
            if k.location then
               local tail = vim.fn.fnamemodify(vim.uri_to_fname(k.location.uri), ':t')
               k.message = tail ..
                   '(' .. (k.location.range.start.line + 1) .. ', ' .. (k.location.range.start.character + 1) ..
                   '): ' .. k.message

               if k.location.uri == vim.uri_from_bufnr(0) then
                  table.insert(result.diagnostics, {
                     code = item.code,
                     message = k.message,
                     range = k.location.range,
                     severity = vim.lsp.protocol.DiagnosticSeverity.Hint,
                     source = item.source,
                     relatedInformation = {},
                  })
               end
            end
            item.message = item.message .. '\n' .. k.message
         end, item.relatedInformation)
      end
   end, result.diagnostics)
   original(_, result, ctx, config)
end


vim.api.nvim_set_keymap('n', '<Leader>d', ':lua vim.diagnostic.open_float()<cr>', { noremap = true, silent = true })

-- To snake case shortcut
vim.api.nvim_set_keymap('n', 'gas', ':lua require("textcase").current_word("to_snake_case")<CR>', { noremap = true, silent = true })

local function init_colorscheme()
  vim.opt.termguicolors = true
  -- Try to find the .colorrc file I use for toggling dark and light themes.
  local colorrc_file = vim.env.HOME .. '/.vimrc.color'

  local function resource_colorrc()
    vim.cmd('source ' .. colorrc_file)
  end

  if vim.fn.filereadable(colorrc_file) == 1 then
    resource_colorrc()
    require('fwatch').watch(colorrc_file, "source " .. colorrc_file)
  else
    vim.cmd.colorscheme('gruvbox-material')
  end
end
init_colorscheme()


local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- lspconfig.clangd.setup({
--   capabilities = capabilities,
--   cmd = {
--     "clangd",
--     "--query-driver=/usr/bin/c++,/usr/bin/cc,/usr/bin/gcc*,/usr/bin/clang*",
--     "--completion-style=detailed",
--   },
--   on_attach = function(client, bufnr)
--     local navic = require("nvim-navic")
--     if client.server_capabilities.documentSymbolProvider then
--       navic.attach(client, bufnr)
--     end
--   end
-- })
lspconfig.ccls.setup({
   capabilities = capabilities,
   on_attach = function(client, bufnr)
     local navic = require("nvim-navic")
     if client.server_capabilities.documentSymbolProvider then
       navic.attach(client, bufnr)
     end
   end
})
lspconfig.pylsp.setup({
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'E402'},
          maxLineLength = 180
        }
      }
    }
  },
  on_attach = function(client, bufnr)
    local navic = require("nvim-navic")
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end
})
lspconfig.rust_analyzer.setup({
   capabilities = capabilities,
})

lspconfig.tinymist.setup {
    settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable"
    }
}

lspconfig.texlab.setup {
  capabilities = capabilities,
  settings = {
    texlab = {
      formatterLineLength = 0,
    }
  },
}

vim.api.nvim_create_user_command("TypstPinMain", function()
  vim.lsp.buf.execute_command({ command = 'tinymist.pinMain', arguments = { vim.api.nvim_buf_get_name(0) } })
end, {})
vim.api.nvim_create_user_command("TypstUnpinMain", function()
  vim.lsp.buf.execute_command({ command = 'tinymist.pinMain', arguments = { nil } })
end, {})

--lspconfig.jails.setup({
--  capabilities = capabilities,
--  cmd = { "/home/martijn/3rd/jai/Jails/bin/jails" },
--  filetypes = { "jai" },
--  root_dir = lspconfig.util.root_pattern("first.jai", "build.jai"),
--})


-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    --vim.keymap.set('n', '<space>wl', function()
    --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, opts)
    --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set({'n', 'v'}, '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    vim.o.winbar = "[%{%v:lua.require'nvim-navic'.get_location()%}]"

    -- Enable borders on popups.
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    --require("lsp_signature").on_attach()
  end,
})


-- After a re-source, fix syntax matching issues (concealing brackets):
if vim.g.loaded_webdevicons then
  vim.fn['webdevicons#refresh']()
end

require("nvim-tree").setup{
  hijack_netrw = false,
  hijack_unnamed_buffer_when_opening = true,
  respect_buf_cwd = true,
  actions = {
    open_file = {
      window_picker = {
        enable = false
      },
      quit_on_open = true
    },
  },
}
nvimtree_api = require("nvim-tree.api")
vim.keymap.set('n', '<leader>e', nvimtree_api.tree.open)

require('mini.align').setup()
--require("focus").setup()

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
  vim.g.neovide_cursor_vfx_particle_highlight_lifetime = 1.8


  -- Font size changing
  vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")

  -- Copy paste with clipboard
  --vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<C-S-c>', '"+y') -- Copy
  vim.keymap.set('n', '<C-S-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<C-S-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<C-S-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<C-S-v>', '<ESC>"+pa') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
--vim.api.nvim_set_keymap('' , '<D-v>', '+p<CR>', { noremap = true, silent = true})
--vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
--vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
--vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})

