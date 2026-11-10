" ~/.vimrc -- the Vim twin of ~/.config/nvim
"
" Same look (tokyonight-night plus the nvim on_highlights overrides, a
" mini.statusline-style statusline, a mini.tabline-style buffer line) and the
" same keymaps, on stock Vim 9.2 and five plugins. What nvim gets from mini.*
" is hand-rolled below in a few lines each; LSP, DAP and Neogit stay nvim-only.

set nocompatible
set encoding=utf-8
scriptencoding utf-8

let mapleader = ' '
let maplocalleader = ' '

" ============================================================
" Plugins
" ============================================================

let s:plug = expand('~/.vim/autoload/plug.vim')
if !filereadable(s:plug) && executable('curl')
  silent execute '!curl -fsLo' shellescape(s:plug) '--create-dirs'
        \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * ++once PlugInstall --sync | source $MYVIMRC
endif

if filereadable(s:plug)
  call plug#begin('~/.vim/plugged')
  " folke's repo ships a Vim build of the theme, so the colours are the
  " nvim ones exactly (Mini* and GitGutter groups included).
  Plug 'folke/tokyonight.nvim', { 'rtp': 'extras/vim' }
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'airblade/vim-gitgutter'   " stands in for mini.diff
  Plug 'junegunn/fzf.vim'         " stands in for mini.pick
  " Arch's fzf package installs the core Vim plugin system-wide
  if !filereadable('/usr/share/vim/vimfiles/plugin/fzf.vim')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  endif
  call plug#end()
endif

" Packages bundled with Vim 9.1+ that cover nvim built-ins
silent! packadd! comment       " gc / gcc
silent! packadd! nohlsearch    " clear search highlight after 'updatetime'
silent! packadd! hlyank        " flash yanked text
silent! packadd! editorconfig
silent! packadd! matchit
let g:hlyank_duration = 150

filetype plugin indent on
syntax enable

" ============================================================
" Options (mirrors core/options.lua)
" ============================================================

" General
set number relativenumber
set mouse=a
if exists('&ttymouse') | set ttymouse=sgr | endif
set noswapfile nobackup
set undofile undodir=~/.vim/undodir
if !isdirectory(expand(&undodir)) | call mkdir(expand(&undodir), 'p', 0700) | endif

" Indenting
set expandtab shiftwidth=4 tabstop=4 smarttab
set smartindent autoindent

" UI
set cursorline
set termguicolors
if empty(&t_8f)
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let &t_ut = ''                  " no background-colour erase (kitty)
set signcolumn=yes numberwidth=4
set scrolloff=8 sidescrolloff=8
set nowrap
set completeopt=menuone,noinsert,noselect,popup
set wildmenu wildoptions=pum
set shortmess+=IcS              " no intro; search count lives in the statusline
set belloff=all
set display=lastline
set noshowmode
set laststatus=2 showtabline=2
" stlnc: inactive statuslines are drawn as split lines, standing in for the
" nvim global statusline's horiz separators
set fillchars=vert:│,fold:\ ,eob:\ ,diff:╱,stl:\ ,stlnc:─

" Search
set ignorecase smartcase incsearch hlsearch

" Buffers and splits
set splitbelow splitright
set hidden confirm
set switchbuf=uselast

" Timing
set updatetime=200 timeoutlen=300
set ttimeout ttimeoutlen=10

" Whitespace. leadmultispace draws the indent guides; resized per buffer to
" its shiftwidth (see SyncIndentGuides below).
set list
set listchars=tab:»\ ,leadmultispace:·\ \ \ ,trail:·,nbsp:+,extends:›,precedes:‹

" Misc
set lazyredraw
set virtualedit=block
set whichwrap+=<,>,[,]
set backspace=indent,eol,start
set nrformats=bin,hex
set formatoptions+=j
set history=10000
set nostartofline
set foldmethod=indent foldlevel=99 nofoldenable
set spelllang=en_ca
set autoread
silent! set diffopt+=linematch:60

" ============================================================
" Clipboard (clipboard=unnamedplus, like nvim)
" ============================================================
" This Vim is built without +clipboard, but 9.2 clipboard providers fill the
" gap: wl-copy/wl-paste on Wayland, OSC 52 (copy only) everywhere else.

if exists('v:clipproviders')
  if !empty($WAYLAND_DISPLAY) && executable('wl-copy') && executable('wl-paste')
    function! s:WlCopy(reg, type, lines) abort
      let lines = a:type ==# 'V' ? a:lines + [''] : a:lines
      silent call system(a:reg ==# '*' ? 'wl-copy --primary' : 'wl-copy', lines)
    endfunction
    function! s:WlPaste(reg) abort
      silent let out = system(a:reg ==# '*' ? 'wl-paste --primary --no-newline' : 'wl-paste --no-newline')
      if v:shell_error | return ['', []] | endif
      let linewise = out =~# "\n$"
      return [linewise ? 'V' : 'v', split(linewise ? out[: -2] : out, "\n", 1)]
    endfunction
    let v:clipproviders['wlcmd'] = {
          \ 'copy': { '+': function('s:WlCopy'), '*': function('s:WlCopy') },
          \ 'paste': { '+': function('s:WlPaste'), '*': function('s:WlPaste') },
          \ }
    set clipmethod^=wlcmd
  endif
  let g:osc52_disable_paste = 1
  silent! packadd osc52
  set clipmethod+=osc52
  set clipboard=unnamedplus
elseif has('clipboard')
  set clipboard=unnamedplus
endif

" ============================================================
" Colours
" ============================================================

function! s:Highlights() abort
  if get(g:, 'colors_name', '') =~# '^tokyonight'
    " Ports of on_highlights in nvim/lua/plugins/tokyonight.lua
    hi Comment        guifg=#828bb8 gui=italic
    hi SpecialComment guifg=#828bb8 gui=italic
    hi VertSplit      guifg=#3d59a1 guibg=NONE gui=NONE
    " Vim draws 'listchars' whitespace with SpecialKey, nvim with Whitespace
    hi SpecialKey     guifg=#3b4261
    " kitty's background_opacity only reaches cells painted in the default
    " bg (#1a1b26), so the bars sit on that rather than tokyonight's darker
    " #15161e/#16161e
    for group in ['TabLine', 'TabLineFill', 'MiniTablineFill', 'MiniTablineHidden',
          \ 'MiniTablineVisible', 'MiniTablineModifiedHidden',
          \ 'MiniTablineModifiedVisible', 'MiniTablineTrunc', 'StatusLine',
          \ 'MiniStatuslineFilename', 'MiniStatuslineInactive']
      execute 'hi' group 'guibg=#1a1b26'
    endfor
    hi StatusLine   gui=NONE
    hi TabLine      gui=NONE
    hi TabLineFill  gui=NONE
    hi StatusLineNC guifg=#3d59a1 guibg=#1a1b26 gui=NONE
    hi clear StatusLineTerm
    hi clear StatusLineTermNC
    hi! link StatusLineTerm StatusLine
    hi! link StatusLineTermNC StatusLineNC
    " One accent for "active": c.blue chip, c.bg text; unsaved turns yellow
    hi MiniTablineCurrent         guifg=#1a1b26 guibg=#7aa2f7
    hi MiniTablineTabpagesection  guifg=#1a1b26 guibg=#7aa2f7
    hi MiniTablineModifiedCurrent guifg=#1a1b26 guibg=#e0af68
    hi FzfBorder guifg=#3d59a1
  endif

  " In a terminal Vim takes colours from gui* under 'termguicolors' but
  " attributes from cterm=, so italics/bold/undercurl in a GUI-only scheme
  " never show, and Vim's default cterm underline on CursorLine leaks
  " through. Copy every group's gui attributes over to cterm.
  for hl in hlget()
    if !has_key(hl, 'linksto') && get(hl, 'cterm', {}) != get(hl, 'gui', {})
      call hlset([{ 'name': hl.name, 'cterm': get(hl, 'gui', {}) }])
    endif
  endfor
endfunction

augroup VimrcColors
  autocmd!
  autocmd ColorScheme * call s:Highlights()
augroup END

try
  colorscheme tokyonight-night
catch
  colorscheme habamax
endtry

" ============================================================
" Icons (mini.icons glyphs, nerd font)
" ============================================================

let s:icons = map({
      \ 'vim': 0xe7c5, 'lua': 0xf08b1, 'php': 0xf031f, 'go': 0xf07d3,
      \ 'python': 0xf0320, 'javascript': 0xf031e, 'typescript': 0xf06e6,
      \ 'html': 0xf031d, 'css': 0xf031c, 'json': 0xf0626, 'markdown': 0xf0354,
      \ 'sh': 0xe691, 'zsh': 0xe691, 'bash': 0xe691, 'rust': 0xf1617,
      \ 'c': 0xf0671, 'cpp': 0xf0672, 'sql': 0xf01bc, 'yaml': 0xe6a8,
      \ 'toml': 0xe6b2, 'gitcommit': 0xf02a2, 'twig': 0xe61c, 'conf': 0xf0493,
      \ 'make': 0xf1064, 'dockerfile': 0xf0868, 'help': 0xf02d6, 'text': 0xf09aa,
      \ }, 'nr2char(v:val)')
let s:icon_default = nr2char(0xf0214)
let s:icon_git = nr2char(0xe725)
let s:icon_diff = nr2char(0xf4d2)

" Buffers that were never entered have no filetype yet; go by name instead
let s:icon_ext = {
      \ 'py': 'python', 'js': 'javascript', 'mjs': 'javascript', 'ts': 'typescript',
      \ 'md': 'markdown', 'rs': 'rust', 'h': 'c', 'hpp': 'cpp', 'cc': 'cpp',
      \ 'yml': 'yaml', 'txt': 'text', 'mk': 'make', 'vimrc': 'vim',
      \ }

function! s:Icon(buf) abort
  let ft = getbufvar(a:buf, '&filetype')
  if empty(ft)
    let name = fnamemodify(bufname(a:buf), ':t')
    let ext = fnamemodify(name, ':e')
    let ft = name ==# 'Makefile' ? 'make' : name ==# 'Dockerfile' ? 'dockerfile'
          \ : get(s:icon_ext, ext, ext)
  endif
  return get(s:icons, ft, s:icon_default)
endfunction

" ============================================================
" Statusline (mini.statusline layout)
" ============================================================
" mode | git diff | filename ........ searchcount | line:col

let s:modes = {
      \ 'n': ['Normal', 'N', 'Normal'],
      \ 'v': ['Visual', 'V', 'Visual'], 'V': ['V-Line', 'V-L', 'Visual'],
      \ "\<C-v>": ['V-Block', 'V-B', 'Visual'],
      \ 's': ['Select', 'S', 'Visual'], 'S': ['S-Line', 'S-L', 'Visual'],
      \ "\<C-s>": ['S-Block', 'S-B', 'Visual'],
      \ 'i': ['Insert', 'I', 'Insert'],
      \ 'R': ['Replace', 'R', 'Replace'], 'Rv': ['V-Replace', 'V-R', 'Replace'],
      \ 'c': ['Command', 'C', 'Command'],
      \ 'r': ['Prompt', 'P', 'Other'], '!': ['Shell', 'Sh', 'Other'],
      \ 't': ['Terminal', 'T', 'Other'],
      \ }

function! s:GitBranch() abort
  if &buftype !=# '' | let b:git_branch = '' | return | endif
  let dir = expand('%:p:h')
  if !isdirectory(dir) | let dir = getcwd() | endif
  let git = 'git -C ' . shellescape(dir) . ' rev-parse '
  silent let out = systemlist(git . '--abbrev-ref HEAD 2>/dev/null')
  let branch = v:shell_error || empty(out) ? '' : out[0]
  if branch ==# 'HEAD'          " detached: show the short hash, like mini.git
    silent let out = systemlist(git . '--short HEAD 2>/dev/null')
    let branch = v:shell_error || empty(out) ? '' : out[0]
  endif
  let b:git_branch = branch
endfunction

function! s:SearchCount() abort
  if !v:hlsearch | return '' | endif
  try
    let s = searchcount({ 'recompute': 1 })
  catch
    return ''
  endtry
  if empty(s) || s.total == 0 | return '' | endif
  if s.incomplete == 1 | return '?/?' | endif
  let over = '>' . s.maxcount
  return (s.current > s.maxcount ? over : s.current) . '/' . (s.total > s.maxcount ? over : s.total)
endfunction

function! VimrcStatusline() abort
  if get(g:, 'statusline_winid', win_getid()) != win_getid()
    return '%#StatusLineNC#─ %#MiniStatuslineInactive#%f%m%r %#StatusLineNC#%='
  endif
  let width = winwidth(0)
  let m = mode()
  let [long, short, group] = get(s:modes, m, get(s:modes, m[0], [m, m, 'Other']))
  let mode_hl = '%#MiniStatuslineMode' . group . '#'

  let dev = []
  let branch = get(b:, 'git_branch', '')
  if width >= 40 && !empty(branch)
    call add(dev, s:icon_git . ' ' . substitute(branch, '%', '%%', 'g'))
  endif
  if width >= 75 && exists('*GitGutterGetHunkSummary')
    let [added, changed, removed] = GitGutterGetHunkSummary()
    let parts = []
    let hunks = len(GitGutterGetHunks())
    if hunks | call add(parts, '#' . hunks) | endif
    if added | call add(parts, '+' . added) | endif
    if changed | call add(parts, '~' . changed) | endif
    if removed | call add(parts, '-' . removed) | endif
    if !empty(parts) | call add(dev, s:icon_diff . ' ' . join(parts)) | endif
  endif

  " The cell where two side-by-side statuslines meet takes the attribute of
  " the active line's outermost cell, so a bare mode chip would bleed into
  " it. Pad with a neutral cell on each side that has a connected neighbour.
  let [row, col] = win_screenpos(0)
  let [left, right] = [0, 0]
  for nr in range(1, winnr('$'))
    let [r, c] = win_screenpos(nr)
    if nr == winnr() || r + winheight(nr) != row + winheight(0) | continue | endif
    let left = left || c + winwidth(nr) + 1 == col
    let right = right || col + winwidth(0) + 1 == c
  endfor

  let line = (left ? '%#StatusLineNC#─' : '') . mode_hl . ' ' . (width < 120 ? short : long) . ' '
  if !empty(dev)
    let line .= '%#MiniStatuslineDevinfo# ' . join(dev) . ' '
  endif
  let line .= '%<%#MiniStatuslineFilename# ' . (width < 140 ? '%f' : '%F') . '%m%r %='
  let search = width >= 75 ? s:SearchCount() : ''
  if !empty(search)
    let line .= '%#MiniStatuslineFileinfo# ' . search . ' '
  endif
  return line . mode_hl . ' %l:%v ' . (right ? '%#StatusLine# ' : '')
endfunction

set statusline=%!VimrcStatusline()

" ============================================================
" Tabline (mini.tabline: listed buffers, tab-page section)
" ============================================================

" Shortest unique path suffix per buffer: two init.lua -> lua/init.lua etc.
function! s:BufLabels(bufs) abort
  let paths = {}
  let depth = {}
  for b in a:bufs
    let name = bufname(b)
    let paths[b] = empty(name) ? [] : reverse(split(fnamemodify(name, ':p'), '/'))
    let depth[b] = 1
  endfor
  let labels = {}
  for i in range(8)
    let seen = {}
    for b in a:bufs
      if empty(paths[b])
        let labels[b] = getbufvar(b, '&buftype') =~# '^\(nofile\|acwrite\)$' ? '!' : '*'
      else
        let labels[b] = join(reverse(paths[b][0 : depth[b] - 1]), '/')
      endif
      let seen[labels[b]] = get(seen, labels[b], 0) + 1
    endfor
    let clash = filter(copy(a:bufs),
          \ 'seen[labels[v:val]] > 1 && depth[v:val] < len(paths[v:val])')
    if empty(clash) | break | endif
    for b in clash | let depth[b] += 1 | endfor
  endfor
  return labels
endfunction

function! s:Width(items, first, last) abort
  let width = 0
  for item in a:items[a:first : a:last]
    let width += strdisplaywidth(item[1])
  endfor
  return width
endfunction

function! VimrcTabline() abort
  let bufs = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let labels = s:BufLabels(bufs)
  let cur = bufnr('%')
  let shown = tabpagebuflist()
  let items = []
  for b in bufs
    let kind = b == cur ? 'Current' : index(shown, b) >= 0 ? 'Visible' : 'Hidden'
    let hl = 'MiniTabline' . (getbufvar(b, '&modified') ? 'Modified' : '') . kind
    call add(items, [hl, ' ' . s:Icon(b) . ' ' . labels[b] . ' '])
  endfor

  let tabs = tabpagenr('$') > 1 ? ' Tab ' . tabpagenr() . '/' . tabpagenr('$') . ' ' : ''
  " Scroll so the current buffer stays in view
  let avail = &columns - strdisplaywidth(tabs)
  let [first, last] = [0, len(items) - 1]
  let current = index(bufs, cur)
  while first < current && s:Width(items, first, last) > avail
    let first += 1
  endwhile
  while last > max([current, first]) && s:Width(items, first, last) > avail
    let last -= 1
  endwhile

  let line = ''
  if !empty(tabs)
    let line .= '%#MiniTablineTabpagesection#' . tabs
  endif
  for [hl, text] in items[first : last]
    let line .= '%#' . hl . '#' . substitute(text, '%', '%%', 'g')
  endfor
  return line . '%#MiniTablineFill#'
endfunction

set tabline=%!VimrcTabline()

" ============================================================
" Helpers
" ============================================================

let s:sid = expand('<SID>')

" --- mini.bufremove: delete a buffer without closing its windows ---

function! s:SwitchAway(buf) abort
  let alt = bufnr('#')
  if alt > 0 && alt != a:buf && buflisted(alt)
    execute 'buffer' alt
    return
  endif
  silent! bprevious
  if bufnr('%') == a:buf
    enew
  endif
endfunction

function! s:BufRemove(...) abort
  let buf = a:0 && a:1 ? a:1 : bufnr('%')
  if !bufexists(buf) | return | endif
  if getbufvar(buf, '&modified')
    let name = empty(bufname(buf)) ? '[No Name]' : bufname(buf)
    let choice = confirm('Save changes to "' . name . '"?', "&Yes\n&No\n&Cancel", 3)
    if choice == 3 || choice == 0 | return | endif
    if choice == 1
      try
        let wins = win_findbuf(buf)
        if !empty(wins)
          call win_execute(wins[0], 'update')
        else
          let cur = bufnr('%')
          execute 'keepalt silent buffer' buf
          update
          execute 'keepalt silent buffer' cur
        endif
      catch
        echohl ErrorMsg | echomsg v:exception | echohl None
        return
      endtry
    endif
  endif
  for win in win_findbuf(buf)
    call win_execute(win, 'call ' . s:sid . 'SwitchAway(' . buf . ')')
  endfor
  execute 'silent! bdelete!' buf
endfunction

function! s:BufRemoveWhere(which) abort
  let cur = bufnr('%')
  let bufs = filter(range(1, bufnr('$')), 'buflisted(v:val)')
  let at = index(bufs, cur)
  if a:which ==# 'all'
    let targets = bufs
  elseif a:which ==# 'others'
    let targets = filter(copy(bufs), 'v:val != cur')
  elseif a:which ==# 'left'
    let targets = at > 0 ? bufs[0 : at - 1] : []
  else
    let targets = at >= 0 ? bufs[at + 1 :] : []
  endif
  for b in targets
    call s:BufRemove(b)
  endfor
endfunction

" --- <leader><leader>: most recently used buffer ---

let s:mru = []
function! s:TrackBuffer(buf) abort
  if !buflisted(a:buf) | return | endif
  call filter(s:mru, 'v:val != a:buf')
  call insert(s:mru, a:buf)
endfunction

function! s:LastBuffer() abort
  for b in s:mru
    if b != bufnr('%') && buflisted(b)
      execute 'buffer' b
      return
    endif
  endfor
endfunction

" --- super+hjkl: vim splits -> kitty windows -> Hyprland windows ---
" Hyprland's super+hjkl runs ~/.config/hypr/scripts/nav, which injects
" ctrl+alt+hjkl when the focused kitty window is running vim. At the vim edge,
" hand back to `nav --edge`: it tries the kitty split that way, then Hyprland.
" alt+hjkl resizes vim splits. Same contract as core/nav.lua in nvim.

let s:hypr_nav = expand('~/.config/hypr/scripts/nav')

function! s:Nav(key) abort
  let before = winnr()
  execute 'wincmd' a:key
  if winnr() == before && executable(s:hypr_nav)
    call job_start([s:hypr_nav, '--edge', a:key],
          \ { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
  endif
endfunction

" Resize moves the divider in the key's direction (smart-splits semantics).
function! s:Resize(key) abort
  let horizontal = a:key =~# '[hl]'
  let [before, after] = horizontal ? ['h', 'l'] : ['k', 'j']
  let has_after = winnr(after) != winnr()
  if !has_after && winnr(before) == winnr()
    return
  endif
  let grow = (a:key ==# after) == has_after
  execute (horizontal ? 'vertical ' : '') . 'resize ' . (grow ? '+' : '-') . '3'
endfunction

" --- <C-\>: toggleterm-style bottom terminal ---

function! s:TermToggle() abort
  let buf = get(s:, 'term_buf', -1)
  if bufexists(buf) && term_getstatus(buf) =~# 'running'
    let wins = win_findbuf(buf)
    if !empty(wins)
      for win in wins
        call win_gotoid(win)
        hide
      endfor
      call win_gotoid(get(s:, 'term_prev', 0))
      return
    endif
    let s:term_prev = win_getid()
    botright 20split
    execute 'buffer' buf
    if term_getstatus(buf) =~# 'normal' | call feedkeys('i', 'n') | endif
    return
  endif
  if bufexists(buf) | execute 'silent! bwipeout!' buf | endif
  let s:term_prev = win_getid()
  botright terminal ++rows=20 ++kill=hup ++close
  let s:term_buf = bufnr('%')
  setlocal nobuflisted
  " Buffer-local, so fzf's popup terminal keeps jk and <Esc>
  tnoremap <buffer> <Esc><Esc> <C-\><C-n>
  tnoremap <buffer> jk <C-\><C-n>
  tnoremap <buffer> kj <C-\><C-n>
  for key in ['h', 'j', 'k', 'l']
    execute printf('tnoremap <buffer> <silent> <C-M-%s> <Cmd>call %sNav("%s")<CR>', key, s:sid, key)
  endfor
endfunction

" --- netrw stands in for mini.files ---

function! s:Explore(path) abort
  if &filetype ==# 'netrw'
    silent! Rexplore
    if &filetype ==# 'netrw' | silent! buffer # | endif
    return
  endif
  execute 'Explore' fnameescape(a:path)
endfunction

function! s:ToggleList(loc) abort
  if a:loc
    execute getloclist(0, { 'winid': 0 }).winid ? 'lclose' : 'silent! lopen'
  else
    execute getqflist({ 'winid': 0 }).winid ? 'cclose' : 'copen'
  endif
endfunction

" --- indent guides follow the buffer's shiftwidth ---

function! s:SyncIndentGuides() abort
  let sw = shiftwidth()
  if sw < 1 | return | endif
  let current = empty(&l:listchars) ? &g:listchars : &l:listchars
  let wanted = substitute(current, 'leadmultispace:[^,]*',
        \ 'leadmultispace:·' . repeat(' ', sw - 1), '')
  if wanted !=# &l:listchars | let &l:listchars = wanted | endif
endfunction

" ============================================================
" Keymaps (mirrors core/keymap.lua and the plugin specs)
" ============================================================

nnoremap <leader>? <Cmd>nmap <lt>Space><CR>

" General
nnoremap q <Nop>
nnoremap <silent> <Esc><Esc> <Cmd>nohlsearch<CR>
nnoremap <silent> <leader><leader> <Cmd>call <SID>LastBuffer()<CR>
nnoremap <silent> <leader>q <Cmd>call <SID>BufRemove()<CR>
nnoremap <leader>w <Cmd>w!<CR>
nnoremap <silent> H <Cmd>bprevious<CR>
nnoremap <silent> L <Cmd>bnext<CR>
nnoremap <F5> <Cmd>source $MYVIMRC<CR>
inoremap jk <Esc>
inoremap kj <Esc>
" x, not v: v also covers select mode
xnoremap < <gv
xnoremap > >gv
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

" Find (fzf.vim in place of mini.pick)
nnoremap <leader>ff <Cmd>Files<CR>
nnoremap <leader>fg <Cmd>RG<CR>
nnoremap <leader>fG <Cmd>execute 'Rg' expand('<cword>')<CR>
nnoremap <leader>fb <Cmd>Buffers<CR>
nnoremap <leader>fh <Cmd>Helptags<CR>
nnoremap <leader>fc <Cmd>edit $MYVIMRC<CR>

" Explore
nnoremap <silent> <leader>o  <Cmd>call <SID>Explore(expand('%:p:h'))<CR>
nnoremap <silent> <leader>ed <Cmd>call <SID>Explore(getcwd())<CR>
nnoremap <silent> <leader>ef <Cmd>call <SID>Explore(expand('%:p:h'))<CR>
nnoremap <silent> <leader>eq <Cmd>call <SID>ToggleList(0)<CR>
nnoremap <silent> <leader>el <Cmd>call <SID>ToggleList(1)<CR>

" Buffer
nnoremap <leader>bc <Cmd>enew<CR>
nnoremap <silent> <leader>bq <Cmd>call <SID>BufRemove()<CR>
nnoremap <silent> <leader>bQ <Cmd>call <SID>BufRemoveWhere('all')<CR>
nnoremap <silent> <leader>bo <Cmd>call <SID>BufRemoveWhere('others')<CR>
nnoremap <silent> <leader>bH <Cmd>call <SID>BufRemoveWhere('left')<CR>
nnoremap <silent> <leader>bL <Cmd>call <SID>BufRemoveWhere('right')<CR>
nnoremap <leader>bn <Cmd>bnext<CR>
nnoremap <leader>bp <Cmd>bprevious<CR>
nnoremap <leader>bf <Cmd>bfirst<CR>
nnoremap <leader>bl <Cmd>blast<CR>

" Split
nnoremap <leader>sv <Cmd>vsplit<CR>
nnoremap <leader>sh <Cmd>split<CR>
nnoremap <leader>se <C-w>=
nnoremap <leader>sq <Cmd>close<CR>

" Tab
nnoremap <leader>tc <Cmd>tabnew<CR>
nnoremap <leader>tq <Cmd>tabclose<CR>
nnoremap <leader>tn <Cmd>tabnext<CR>
nnoremap <leader>tp <Cmd>tabprevious<CR>
nnoremap <leader>tf <Cmd>tabfirst<CR>
nnoremap <leader>tl <Cmd>tablast<CR>

" Git hunks (gitgutter in place of mini.diff)
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▁'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_removed_above_and_below = '▁'
let g:gitgutter_sign_modified_removed = '▎'
let g:gitgutter_preview_win_floating = 1
nmap <expr> ]c &diff ? ']c' : '<Plug>(GitGutterNextHunk)'
nmap <expr> [c &diff ? '[c' : '<Plug>(GitGutterPrevHunk)'
nmap <leader>ghs <Plug>(GitGutterStageHunk)
xmap <leader>ghs <Plug>(GitGutterStageHunk)
nmap <leader>ghr <Plug>(GitGutterUndoHunk)
nmap <leader>gho <Plug>(GitGutterPreviewHunk)
nnoremap <leader>ght <Cmd>GitGutterBufferToggle<CR>
nnoremap <leader>ghq <Cmd>GitGutterQuickFixCurrentFile<Bar>copen<CR>

" Window nav / resize (super+hjkl and super-resize, injected by Hyprland)
for s:key in ['h', 'j', 'k', 'l']
  execute printf('nnoremap <silent> <C-M-%s> <Cmd>call <SID>Nav("%s")<CR>', s:key, s:key)
  execute printf('nnoremap <silent> <M-%s> <Cmd>call <SID>Resize("%s")<CR>', s:key, s:key)
endfor

" Terminal
nnoremap <silent> <C-\> <Cmd>call <SID>TermToggle()<CR>

" ============================================================
" Plugin settings
" ============================================================

let g:fzf_layout = { 'window': { 'width': 0.85, 'height': 0.8, 'border': 'rounded' } }
let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Special'],
      \ 'fg+':     ['fg', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine'],
      \ 'hl+':     ['fg', 'Special'],
      \ 'info':    ['fg', 'Comment'],
      \ 'border':  ['fg', 'FzfBorder'],
      \ 'prompt':  ['fg', 'Function'],
      \ 'pointer': ['fg', 'Function'],
      \ 'marker':  ['fg', 'String'],
      \ 'spinner': ['fg', 'Function'],
      \ 'header':  ['fg', 'Comment'],
      \ }

let g:netrw_banner = 0
let g:netrw_altfile = 1        " netrw never becomes the alternate buffer

" ============================================================
" Autocmds (mirrors core/autocmd.lua)
" ============================================================

augroup Vimrc
  autocmd!

  " Restore last cursor position
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$')
        \ | execute 'normal! g`"' | endif

  " Reload files changed outside vim
  autocmd FocusGained,BufEnter,CursorHold * if getcmdwintype() ==# '' | checktime | endif

  " Spell in prose, but not in help/preview buffers
  autocmd FileType gitcommit,markdown let &l:spell = &buftype ==# ''

  autocmd BufWinEnter,FileType * call s:SyncIndentGuides()
  autocmd OptionSet shiftwidth,tabstop call s:SyncIndentGuides()

  " Close with q
  autocmd FileType help,man,qf setlocal nobuflisted
        \ | nnoremap <buffer> <silent> q <Cmd>close<CR>

  " Per-language indent (ftplugin/*.lua)
  autocmd FileType javascript,html,css,lua,sh,cpp,twig
        \ setlocal shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType python,php setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=0 softtabstop=0

  " netrw: h up a directory, l open, q back to the file -- mini.files keys
  autocmd FileType netrw setlocal nobuflisted
        \ | nmap <buffer> h -
        \ | nmap <buffer> l <CR>
        \ | nnoremap <buffer> <silent> q <Cmd>call <SID>Explore('')<CR>

  " Terminal windows: no gutter
  autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn=no nolist nocursorline

  autocmd BufEnter * call s:TrackBuffer(str2nr(expand('<abuf>')))

  " Statusline/tabline inputs that Vim doesn't redraw for on its own
  autocmd BufEnter * if !exists('b:git_branch') | call s:GitBranch() | endif
  autocmd FocusGained,BufWritePost,ShellCmdPost * call s:GitBranch()
  autocmd ModeChanged * redrawstatus
  autocmd User GitGutter redrawstatus
  if exists('##BufModifiedSet')
    autocmd BufModifiedSet * redrawtabline
  endif
augroup END
