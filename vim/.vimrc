set nocompatible              " be iMproved, required
filetype off                  " required

set encoding=UTF-8
set noswapfile

" =================================
" ====== Set the Leaderkey   ======
" =================================
let mapleader = ","
let maplocalleader = "_"

" ==========================
" ====== Load Plugins ======
" ==========================
" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.Vim
call vundle#begin()
" Vundle manages itself
Plugin 'VundleVim/Vundle.vim'
Plugin 'dylanaraps/wal.vim'

" Add other plugins to Vundle
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'
Plugin 'embear/vim-localvimrc'
Plugin 'SirVer/ultisnips'
Plugin 'easymotion/vim-easymotion'
Plugin 'luochen1990/rainbow'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'chriskempson/base16-vim'
Plugin 'honza/vim-snippets'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'fedorenchik/VimCalc3'
Plugin 'nathanaelkane/vim-indent-guides'

Plugin 'editorconfig/editorconfig-vim'

" Git diff highlight
Plugin 'airblade/vim-gitgutter'

" C/C++
Plugin 'valloric/youcompleteme'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'majutsushi/tagbar'
"Plugin 'Kypert/vim-clang-format', { 'branch' : 'fix/issues/98' }
Plugin 'rhysd/vim-clang-format'
Plugin 'tpope/vim-dispatch'
Plugin 'vim-scripts/DoxygenToolkit.vim'
Plugin 'AndrewRadev/sideways.vim'
"if !has('nvim')
"Plugin 'mcourteaux/color_coded'
"endif

" Python
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-python/python-syntax'

" Java
Plugin 'artur-shaik/vim-javacomplete2'

" Tex
Plugin 'lervag/vimtex'

" GLSL
"Plugin 'tikhomirov/vim-glsl'
Plugin 'beyondmarc/glsl.vim'

" Haskell
Plugin 'neovimhaskell/haskell-vim'

" Random plugin
Plugin 'itchyny/calendar.vim'
Plugin 'mhinz/vim-startify'
Plugin 'aserebryakov/vim-todo-lists'

let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
Plugin 'ryanoasis/vim-devicons'



call vundle#end()
filetype plugin on


let g:python_highlight_all = 1

" =========================
" ====== Set the LaF ======
" =========================

" Line numbers
set number
"highlight LineNr ctermfg=red
"highlight LineNr ctermbg=black

" Highlight current line
"set cursorline
"highlight CursorLine cterm=NONE ctermbg=black

" Color
if has("gui_running")
    if has("gui_macvim")
        colorscheme evening
        set guioptions-=r
        set guioptions-=R
        set guioptions-=l
        set guioptions-=L
	"set guifont=Source\ Code\ Pro\ for\ Powerline:h11
        set guifont=FuraMono\ Nerd\ Font:h11
    endif
endif
syntax on


" Search
set incsearch
set hlsearch

" Partial commands
set showcmd

" Allow backspace
set backspace=2

" Doxygen highlight
let g:load_doxygen_syntax=1

" ===========================================
" ====== Set some default indent rules ======
" ===========================================

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
filetype plugin indent on
set smartindent

let g:indent_guides_space_guides=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

" execute "set colorcolumn=" . join(range(81,335), ',')

" =======================================
" ====== Some special characters   ======
" =======================================

imap ∫ ₿

" ====================================
" ====== Some random vim tweaks ======
" ====================================

" Use system clipboard
set clipboard=unnamed

" Enable mouse mode
set mouse=a
if !has('nvim')
    set ttymouse=xterm2
endif

" Automatically change the pwd to the file
autocmd BufEnter * silent! lcd %:p:h

" On split, move cursor to new split
set splitbelow
set splitright

" Allow for non-save buffers
set hidden

" Offset the top and bottom while scrolling
set scrolloff=5
set scrolljump=10

" Highlight trailling whitespace
"set list
set listchars=trail:·,tab:>-

" Show command completion suggestions
set wildmenu

" Folding tricks
nnoremap <space> za
vnoremap <space> zf

syn region pythonFunctionFold  start="^\z(\s*\)\%(def\|class\)\>"
      \ keepend
      \ end="\S\n\%(\s*\n\)\{,2}\ze\%(\s*\n\)*\%(\z1\s\)\@!."
      \ end="\%(\_^\s*\n\)*\%$"
      \ fold transparent

" =======================================
" ====== Some random neovim tweaks ======
" =======================================

if has('nvim')
    tnoremap <Esc><Esc> <C-\><C-n>
endif

" ================================
" ====== Configure Plugins  ======
" ================================

" (1) tagbar
set tags=tags;/
if isdirectory(expand("~/.vim/bundle/tagbar/"))
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
    autocmd FileType tagbar setlocal nocursorline nocursorcolumn
endif

" (2) FSwitch (toggle source/header)
noremap <Leader>a :FSHere<CR>
noremap <Leader>v :FSRight<Cr>
noremap <Leader>V :FSSplitRight<Cr>
noremap <Leader>s :FSBelow<Cr>
noremap <Leader>S :FSSplitBelow<Cr>

" Make it swap out the *last* occurence of "include" and "src"
au! BufEnter *.h   let b:fswitchlocs = 'reg:/.*\zsinclude/src/'
au! BufEnter *.hpp let b:fswitchlocs = 'reg:/.*\zsinclude/src/'
au! BufEnter *.cpp let b:fswitchlocs = 'reg:/.*\zssrc/include/'

" (3) Airline Theme
set laststatus=2
let g:airline_theme = 'badwolf'
let g:airline_powerline_fonts = 1

"" (4) Load colorscheme
"let base16colorspace=256  " Access colors present in 256 colorspace
"
"if filereadable(expand("~/.vimrc_background"))
"    let base16colorspace=256
"    source ~/.vimrc_background
"else
"    set background=dark
"    colorscheme default
"endif

"if has('unix')
"    if !has('macunix')
"        colorscheme wal
"    endif
"endif
" hi Normal ctermbg=none

" Over length
autocmd FileType cpp,hpp,c,h highlight OverLength ctermbg=red
autocmd FileType cpp,hpp,c,h match OverLength /\%81v.\+/

" (5) Clang-Format
if isdirectory(expand("~/.vim/bundle/vim-clang-format/"))
    nnoremap <silent> <leader>f :ClangFormat<CR>
endif

" (6) No sandbox for localvimrc
let g:localvimrc_sandbox=0
let g:localvimrc_persistent=1

" (7) UltiSnippet
let g:UltiSnipsExpandTrigger="<c-L>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" (8) NERDTree
noremap <Leader>e :NERDTreeFocus<CR>

" (9) CtrlP
noremap <Leader>b :CtrlPBuffer<CR>
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" (10) RainbowBraces
let g:rainbow_active = 1
let g:rainbow#max_level = 8
let g:rainbow_conf = {
\   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
\   'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'red', 'green', 'yellow'],
\   'operators': '_,_',
\   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\   'separately': {
\       '*': {},
\       'tex': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
\       },
\       'lisp': {
\           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
\       },
\       'vim': {
\           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
\       },
\       'html': {
\           'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
\       },
\       'css': 0,
\       'cmake': 0,
\   }
\}


" (11) Git Gutter
"
" Faster updatetime
" (useful for vim-gitgutter)
" (default is 4000)
set updatetime=500

" Colors for highlights
let g:gitgutter_highlight_lines = 0
"highlight clear DiffAdd
"highlight clear DiffChange
"highlight clear DiffDelete
highlight DiffAdd    guibg=#2b2e2a
highlight DiffChange guibg=#292b3d
highlight DiffDelete guibg=#382a2e

" (12) Java Completion
autocmd FileType java setlocal omnifunc=javacomplete#Complete
noremap <Leader><Leader>I <Plug>(JavaComplete-Imports-Add)
noremap <Leader>I :YcmCompleter OrganizeImports<CR>
noremap <Leader>F :YcmCompleter FixIt<CR>

" (13) VimTex configuration
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme
let g:tex_flavor = 'latex'
let g:tex_fast = 'cmMpr'
let g:ycm_filetype_blacklist = {
      \ 'tagbar': 1,
      \ 'qf': 1,
      \ 'notes': 1,
      \ 'markdown': 1,
      \ 'unite': 1,
      \ 'text': 1,
      \ 'vimwiki': 1,
      \ 'pandoc': 1,
      \ 'infolog': 1,
      \ 'mail': 1,
      \ 'julia': 1,
      \ 'java': 1
      \}
noremap <LocalLeader>lv :VimtexView<CR>

if has('macunix')
    let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
    let g:vimtex_view_general_options = '-r @line @pdf @tex'
    let g:vimtex_fold_enabled = 0 "So large files can open more easily
elseif has('unix')
    let g:vimtex_view_method = 'zathura'
endif

" (14) C-style (Java / C++) argument objects for "cia" -> "change in argument"
omap aa <Plug>SidewaysArgumentTextobjA
xmap aa <Plug>SidewaysArgumentTextobjA
omap ia <Plug>SidewaysArgumentTextobjI
xmap ia <Plug>SidewaysArgumentTextobjI

" (15) YouCompleteMe
let g:ycm_use_clangd = 0
let g:ycm_clangd_args=['--header-insertion=never']
nnoremap gd :YcmCompleter GoTo<CR>
let g:ycm_disable_signature_help=0
let g:ycm_auto_hover=''
nmap <leader>d <plug>(YCMHover)

if has('macunix')
    let g:ycm_clangd_binary_path = '/usr/local/Cellar/llvm/11.0.0/bin/clangd'
endif

" (16) Python SimplyIFold
let g:SimpylFold_fold_docstring = 0

" (17) FZF (Alternative to CtrlP) These are C/C++ specific right now...
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
