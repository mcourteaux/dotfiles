""" NEOVIM config

set encoding=UTF-8
set noswapfile

let mapleader = ","
let maplocalleader = "_"

"let g:base16_transparent_background=1
set termguicolors "Enable full RGB colors.

" === Python support
" Disable python2 support
let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python3'
set pyxversion=3

call plug#begin()

" Color scheme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
"Plug 'chriskempson/base16-vim'
Plug 'Soares/base16.nvim'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/vim-github-dashboard'

" Various tools
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'

" C/C++
Plug 'valloric/youcompleteme'
Plug 'derekwyatt/vim-fswitch'
Plug 'rhysd/vim-clang-format'
Plug 'AndrewRadev/sideways.vim'

" Tex
Plug 'lervag/vimtex'

call plug#end()


" General config
set number            "Line numbers
syntax on
set backspace=2       "Allow backspace
set hidden            "Allow for non-save buffers
set clipboard=unnamed " Use system clipboard
set showcmd           "Show partial commands in the bottomright
set wildmenu          " Show command completion suggestions

" Automatically change the pwd to the file
autocmd BufEnter * silent! lcd %:p:h

" Enable mouse mode
set mouse=a
if !has('nvim')
    set ttymouse=xterm2
endif

" Search
set incsearch    "Incremential searching
set hlsearch     "Highlight matches
set smartcase    "Smart case searching

" Indentation
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
filetype plugin indent on

" Highlight trailling whitespace
set listchars=trail:·,tab:>-


" On split, move cursor to new split
set splitbelow
set splitright

" Folding tricks
nnoremap <space> za
vnoremap <space> zf

" Over length marking
autocmd FileType cpp,hpp,c,h highlight OverLength ctermbg=blue
autocmd FileType cpp,hpp,c,h match OverLength /\%81v.\+/

" ===  FSwitch (toggle source/header)
noremap <Leader>a :FSHere<CR>
noremap <Leader>v :FSRight<Cr>
noremap <Leader>V :FSSplitRight<Cr>
noremap <Leader>s :FSBelow<Cr>
noremap <Leader>S :FSSplitBelow<Cr>
" Make it swap out the *last* occurence of "include" and "src"
au! BufEnter *.h   let b:fswitchlocs = 'reg:/.*\zsinclude/src/'
au! BufEnter *.hpp let b:fswitchlocs = 'reg:/.*\zsinclude/src/'
au! BufEnter *.cpp let b:fswitchlocs = 'reg:/.*\zssrc/include/'

" === NERDTree
noremap <Leader>e :NERDTreeFocus<CR>



" === VimTex configuration
noremap <LocalLeader>lv :VimtexView<CR>

" === C-style (Java / C++) argument objects for "cia" -> "change in argument"
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

" === YouCompleteMe
let g:ycm_use_clangd = 0
let g:ycm_clangd_args=['--header-insertion=never']
nnoremap gd :YcmCompleter GoTo<CR>
let g:ycm_disable_signature_help=0
let g:ycm_auto_hover=''
nmap <leader>d <plug>(YCMHover)
if has('macunix')
    let g:ycm_clangd_binary_path = '/usr/local/Cellar/llvm/11.0.0/bin/clangd'
endif

" === FZF
" These are C/C++ specific right now...
"let $FZF_DEFAULT_COMMAND = '(fd --type f --regex ".*\.(cpp|hpp|c|h)$" ; fd --type f -E "*.cpp" -E "*.hpp" -E "*.h" -E "*.c" )'
"let $FZF_DEFAULT_OPTS = '--tiebreak=index'
set rtp+=/usr/local/opt/fzf
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf/
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! ProjectFiles execute 'Files' s:find_git_root()
noremap <C-p> :ProjectFiles<CR>

command! SuperProjectFiles execute 'Files' s:find_git_root() . '/../'
noremap <Leader><C-p> :SuperProjectFiles<CR>

command! ProjectTestFiles execute 'Files' s:find_git_root() . '/test'
noremap <C-t> :ProjectTestFiles<CR>

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" === Color theme
:lua require('colorscheme_watcher')
