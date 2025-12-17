" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Plugins
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'itchyny/lightline.vim'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }

call plug#end()

" Turn on syntax highlighting
syntax on

set termguicolors

" No startup messages
set shortmess+=I

" For plugins to load correctly
filetype plugin indent on

let mapleader = " "

set nowrap

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" Security
set modelines=0

" Show line numbers
set number
set relativenumber

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell
" Don't flash the screen tho
set t_vb=

" Encoding
set encoding=utf-8

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Status bar config
set statusline+=%#warningmsg#

" Formatting
set colorcolumn=80
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set smartindent

let &t_ut=''

" Cursor motion
set scrolloff=6
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim


set guicursor=
set modifiable

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
set mouse=a

" Color scheme (terminal)
set t_Co=256

colorscheme catppuccin_macchiato

" Status Bar
set laststatus=2
set cmdheight=1
let g:lightline = {'colorscheme': 'catppuccin_macchiato'}

"hi Normal guibg=NONE ctermbg=NONE

" Mappings
nnoremap <ESC><ESC> :noh<CR>
nnoremap <leader><Space> :w<CR>

" Picker
nnoremap <C-p> :FZF<CR>
nnoremap <leader>ff :FZF<CR>

" Quit
nnoremap <leader>Q :qa<CR>

" Windows
nnoremap <leader>wq :q<CR>

" Tabs
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt
nnoremap <leader>0 :tablast<CR>
nnoremap H :tabprev<CR>
nnoremap L :tabnext<CR>

" Window nav
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resize
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>

" Splits
nnoremap <leader>wv :vsplit<CR>
nnoremap <leader>ws :sp<CR>
highlight VertSplit guifg=#585b70 guibg=#1e1e2e ctermfg=grey ctermbg=black

" Fixes
nnoremap j gj
nnoremap k gk
imap jk <ESC>
imap kj <ESC>

" Move text
vnoremap < <gv
xnoremap < <gv
vnoremap > >gv
xnoremap > >gv

" Clipboard
if (!has('nvim') && !has('clipboard_working'))
    " In the event that the clipboard isn't working, it's quite likely that
    " the + and * registers will not be distinct from the unnamed register. In
    " this case, a:event.regname will always be '' (empty string). However, it
    " can be the case that `has('clipboard_working')` is false, yet `+` is
    " still distinct, so we want to check them all.
    let s:VimOSCYankPostRegisters = ['', '+', '*']
    function! s:VimOSCYankPostCallback(event)
        if a:event.operator == 'y' && index(s:VimOSCYankPostRegisters, a:event.regname) != -1
            call OSCYankRegister(a:event.regname)
        endif
    endfunction
    augroup VimOSCYankPost
        autocmd!
        autocmd TextYankPost * call s:VimOSCYankPostCallback(v:event)
    augroup END
endif

" Filetype
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType html       setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css        setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python     setlocal shiftwidth=4 softtabstop=4 expandtab
