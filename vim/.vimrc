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
Plug 'ghifarit53/tokyonight-vim'
Plug 'itchyny/lightline.vim'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }

call plug#end()

" For plugins to load correctly
filetype plugin indent on

" --- General ---
set encoding=utf-8
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set hidden
set modelines=0
set mouse=a
set updatetime=200
set timeoutlen=300
set autoread

" --- UI ---
set number
set relativenumber
set cursorline
set termguicolors
set guicursor=
set signcolumn=yes
set scrolloff=8
set sidescrolloff=8
set nowrap
set colorcolumn=80
set laststatus=2
set cmdheight=1
set noshowmode
set visualbell
set t_vb=
set splitbelow
set splitright
set shortmess+=I

" --- Indentation ---
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set autoindent
set noshiftround

" --- Search ---
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" --- Performance ---
set ttyfast
set lazyredraw

" --- Misc ---
set backspace=indent,eol,start
set matchpairs+=<:>
runtime! macros/matchit.vim
set t_Co=256
let &t_ut=''
set completeopt=menuone,noinsert,noselect

" --- Theme ---
let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
colorscheme tokyonight

" --- Statusline ---
let g:lightline = {'colorscheme': 'tokyonight'}

" --- Leader ---
let mapleader = " "

" ============================================================
" Keymaps
" ============================================================

" Clear search highlight
nnoremap <ESC><ESC> :noh<CR>

" Save / Quit
nnoremap <leader><Space> :w<CR>
nnoremap <leader>Q :qa<CR>

" Last buffer
nnoremap <BS> :b#<CR>

" Picker
nnoremap <leader>ff :FZF<CR>

" Buffer nav (H/L like nvim)
nnoremap H :bprev<CR>
nnoremap L :bnext<CR>

" Buffer group
nnoremap <leader>bc :enew<CR>
nnoremap <leader>bq :bd<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
nnoremap <leader>bf :bfirst<CR>
nnoremap <leader>bl :blast<CR>

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

" Window group
nnoremap <leader>wc :new<CR>
nnoremap <leader>wq :q<CR>
nnoremap <leader>wQ :qall<CR>
nnoremap <leader>ws :split<CR>
nnoremap <leader>wv :vsplit<CR>

" Tab group
nnoremap <leader>tc :tabnew<CR>
nnoremap <leader>tq :tabclose<CR>
nnoremap <leader>tn :tabnext<CR>
nnoremap <leader>tp :tabprev<CR>
nnoremap <leader>tf :tabfirst<CR>
nnoremap <leader>tl :tablast<CR>
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

" UI toggles
nnoremap <leader>un :set relativenumber! \| set number!<CR>
nnoremap <leader>ur :set relativenumber!<CR>
nnoremap <leader>uw :set wrap!<CR>
nnoremap <leader>us :set spell!<CR>
nnoremap <leader>ul :set list!<CR>
nnoremap <leader>uh :set hlsearch!<CR>
nnoremap <leader>ui :set cursorline!<CR>
nnoremap <leader>ua :set autoindent!<CR>
nnoremap <leader>uP :set paste!<CR>
nnoremap <leader>ue :set expandtab!<CR>
nnoremap <leader>uc :if &colorcolumn == '' \| set colorcolumn=80 \| else \| set colorcolumn= \| endif<CR>

" Fixes: move through wrapped lines naturally
nnoremap j gj
nnoremap k gk

" Insert mode escape
imap jk <ESC>
imap kj <ESC>
imap <leader>w <ESC>:update<CR>a

" Visual mode indenting
vnoremap < <gv
xnoremap < <gv
vnoremap > >gv
xnoremap > >gv

" Move selected lines up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" ============================================================
" Autocmds
" ============================================================

" Restore last cursor position
augroup RestoreCursor
    autocmd!
    autocmd BufReadPost *
        \ let l:line = line("'\"") |
        \ if l:line > 0 && l:line <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
augroup END

" Auto-reload file when changed outside vim
augroup AutoReload
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold * checktime
augroup END

" Spell check in prose filetypes
augroup SpellCheck
    autocmd!
    autocmd FileType gitcommit,markdown setlocal spell spelllang=en_ca
augroup END

" Clear search highlight when cursor moves in normal mode
augroup ClearSearch
    autocmd!
    autocmd CursorMoved * if v:hlsearch && mode() ==# 'n' | nohlsearch | endif
augroup END

" ============================================================
" Clipboard (OSC Yank for terminals without clipboard)
" ============================================================

if (!has('nvim') && !has('clipboard_working'))
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

" ============================================================
" Filetype overrides
" ============================================================

augroup FiletypeIndent
    autocmd!
    autocmd FileType javascript,html,css setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType python              setlocal shiftwidth=4 softtabstop=4 expandtab
augroup END
