vim.o.encoding = "UTF-8"
vim.o.swapfile = false
vim.g.mapleader = ","
vim.g.maplocalleader = "_"


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
--local openai_api_key = vim.fn.join(vim.fn.readfile(vim.fn.expand("~/.config/vim-chatgpt.key")))
local openai_api_key_file = io.open(os.getenv("HOME") .. "/.config/vim-chatgpt.key", "r")
if not openai_api_key_file then
    error("Failed to open the OpenAI API key file: ~/.config/vim-chatgpt.key")
end
local openai_api_key = openai_api_key_file:read("*all")
openai_api_key = string.gsub(openai_api_key, "\n$", "") -- Strip trailing newline
openai_api_key_file:close()

vim.g.openai_api_key = openai_api_key

-- Utility function to find the git project root
find_git_root = function()
  return vim.fn.system('git rev-parse --show-toplevel 2> /dev/null'):sub(1,-2)
end


-- Actually load lazy.nvim
require("lazy").setup({
  -- LSP
  { 'neovim/nvim-lspconfig' },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
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
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
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
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          -- { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
      })

      -- Set up lspconfig.
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
      require('lspconfig')['clangd'].setup {
        capabilities = capabilities
      }

    end
  },

  -- Colorschemes
  {'folke/tokyonight.nvim'},
  -- { 'Soares/base16.nvim' , config=function() vim.cmd.colorscheme('summerfruit') end },
  { 'RRethy/nvim-base16' , config=function() vim.cmd.colorscheme('base16-summerfruit-dark') end },

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
        fzf.files({ cwd = find_git_root() })
      end)
      -- Super Project Files
      vim.keymap.set('n', '<Leader><c-P>', function()
        fzf.files({ cwd = find_git_root() .. '/../' })
      end)
      -- Project Test Files
      vim.keymap.set('n', '<Leader><c-P>', function()
        fzf.files({ cwd = find_git_root() .. '/test/' })
      end)
      -- Project Lines
      vim.keymap.set('n', '<Leader>L', function()
        fzf.live_grep({ cwd = find_git_root() })
      end)
    end
  },

  -- Various Tools
  { 'easymotion/vim-easymotion' },
  { 'editorconfig/editorconfig-vim' },
  { 'scrooloose/nerdtree' },
  { 'ntpeters/vim-better-whitespace' },
  { 'Konfekt/vim-sentence-chopper' },
  {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Syntax Highlighting Plugins
  { 'beyondmarc/glsl.vim' },
  { 'rluba/jai.vim' },

  -- C++
  {
    'rhysd/vim-clang-format', config = function() 
      vim.api.nvim_set_keymap('n', '<Leader>f', ':ClangFormat<CR>', { noremap = true, silent = true })
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
  --{
  --  'ycm-core/youcompleteme',
  --  build = 'python3 ./install.py --clang-completer',
  --  config = function()
  --    -- YouCompleteMe
  --    vim.g.ycm_use_clangd = 0
  --    vim.g.ycm_clangd_args = { '--header-insertion=never' }
  --    vim.g.ycm_disable_signature_help = 0
  --    vim.g.ycm_auto_hover=''
  --    vim.g.ycm_auto_trigger = 1

  --    -- nnoremap gd :YcmCompleter GoTo<CR>
  --    vim.api.nvim_set_keymap('n', 'gd', ':YcmCompleter GoTo<CR>', { noremap = true, silent = true })

  --    -- nnoremap <leader>F :YcmCompleter FixIt<CR>
  --    vim.api.nvim_set_keymap('n', '<leader>F', ':YcmCompleter FixIt<CR>', { noremap = true, silent = true })

  --    -- nmap <leader>d <plug>(YCMHover)
  --    vim.api.nvim_set_keymap('n', '<leader>d', '<plug>(YCMHover)', { noremap = true, silent = true })
  --  end
  --},

  -- Python
  { 'tmhedberg/SimpylFold' },

  -- VimTex
  {
    'lervag/vimtex',
    config = function()
      vim.api.nvim_set_keymap('n', '<LocalLeader>lv', ':VimtexView<CR>', { noremap = true })
      if vim.fn.has('macunix') == 1 then
        vim.g.vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
        vim.g.vimtex_view_general_options = '-r @line @pdf @tex'
        vim.g.vimtex_fold_enabled = 0 -- So large files can open more easily
      elseif vim.fn.has('unix') == 1 then
        vim.g.vimtex_view_method = 'zathura'
      end
    end
  },


  -- ChatGPT stuff
  {
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
  },
  {
    "thmsmlr/gpt.nvim",
    config = function()
      require('gpt').setup({
        api_key = openai_api_key
      })

      opts = { silent = true, noremap = true }
      vim.keymap.set('v', '<C-g>r', require('gpt').replace, {
        silent = true,
        noremap = true,
        desc = "[G]pt [R]ewrite"
      })
      vim.keymap.set('v', '<C-g>p', require('gpt').visual_prompt, {
        silent = false,
        noremap = true,
        desc = "[G]pt [P]rompt"
      })
      vim.keymap.set('n', '<C-g>p', require('gpt').prompt, {
        silent = true,
        noremap = true,
        desc = "[G]pt [P]rompt"
      })
      vim.keymap.set('n', '<C-g>c', require('gpt').cancel, {
        silent = true,
        noremap = true,
        desc = "[G]pt [C]ancel"
      })
      vim.keymap.set('i', '<C-g>p', require('gpt').prompt, {
        silent = true,
        noremap = true,
        desc = "[G]pt [P]rompt"
      })
    end
  }
})
vim.opt.termguicolors = true
--vim.cmd.colorscheme('tokyonight')

vim.o.number = true
vim.o.autochdir = true
vim.o.showcmd = true
vim.o.hidden = true
vim.o.backspace = 2

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

local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--query-driver=/usr/bin/c++,/usr/bin/cc,/usr/bin/gcc*,/usr/bin/clang*",
    "--completion-style=detailed",
  },
})

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
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
 
    -- Enable borders on popups.
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    require("lsp_signature").on_attach()
  end,
})
