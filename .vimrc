" -*- vim: set sts=2 sw=2 et fdm=marker: -------------  vim modeline -*-
set nocompatible

" Functions {{{
function! Preserve(command) "{{{
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  execute a:command
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction "}}}
function! StripTrailingWhitespace() "{{{
  call Preserve("%s/\\s\\+$//e")
endfunction "}}}
function! EnsureExists(path) "{{{
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path))
  endif
endfunction "}}}
function! CloseWindowOrKillBuffer() "{{{
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

  " never bdelete a nerd tree
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif

  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction "}}}
" }}}
" vim-plug {{{

" download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://github.com/junegunn/vim-plug/raw/ca0ae0a8b1bd6380caba2d8be43a2a19baf7dbe2/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

" Some werid path for shared plugins files.
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible', { 'commit': '624c7549a5dfccef2030acc545198d102e4be1c0' }

" UI
Plug 'tmux-plugins/vim-tmux', { 'commit': 'cfe76281efc29890548cf9eedd42ad51c7a1faf0' }
Plug 'vim-airline/vim-airline', { 'commit': 'cead8efb48fbd770757f74246fefd1a3c7bec8ef' }
Plug 'vim-airline/vim-airline-themes', { 'commit': 'dd81554c2231e438f6d0e8056ea38fd0e80ac02a' }
Plug 'nanotech/jellybeans.vim', { 'commit': 'ef83bf4dc8b3eacffc97bf5c96ab2581b415c9fa' }
Plug 't9md/vim-choosewin', { 'commit': '839da609d9b811370216bdd9d4512ec2d0ac8644' }
Plug 'qpkorr/vim-bufkill', { 'commit': '2bd6d7e791668ea52bb26be2639406fcf617271f' }
Plug 'mihaifm/bufstop', { 'commit': '51a87fb1fb3031778b465c5c92007ebd1ac677f6' }
Plug 'majutsushi/tagbar', { 'commit': 'be563539754b7af22bbe842ef217d4463f73468c' }
Plug 'scrooloose/nerdtree', { 'commit': 'c46e12a886b4a6618a9e834c90f6245952567115' }

" Basic Editing
Plug 'simnalamburt/vim-mundo', { 'commit': 'b53d35fb5ca9923302b9ef29e618ab2db4cc675e' }
Plug 'tomtom/tcomment_vim', { 'commit': 'b4930f9da28647e5417d462c341013f88184be7e' }
Plug 'tpope/vim-unimpaired', { 'commit': '6d44a6dc2ec34607c41ec78acf81657248580bf1' }
Plug 'justinmk/vim-sneak', { 'commit': '29ec9167d4a609f74c130b46265aa17eb2736e6a' }
Plug 'chrisbra/NrrwRgn', { 'commit': 'e027db9d94f94947153cd7b5ac9abd04371ab2b0' }
Plug 'terryma/vim-expand-region', { 'commit': '966513543de0ddc2d673b5528a056269e7917276' }
Plug 'tpope/vim-surround', { 'commit': '3d188ed2113431cf8dac77be61b842acb64433d9' }
Plug 'tpope/vim-eunuch', { 'commit': '67f3dd32b4dcd1c427085f42ff5f29c7adc645c6' }
Plug 'b4winckler/vim-angry', { 'commit': '08e9e9a50e6683ac7b0c1d6fddfb5f1235c75700' }

" Nice to have
" this maps to https://github.com/nvim-pack/nvim-spectre in neovim
Plug 'dyng/ctrlsf.vim', { 'commit': '32236a8b376d9311dec9b5fe795ca99d32060b13' }
Plug 'ctrlpvim/ctrlp.vim', { 'commit': '7c972cb19c8544c681ca345c64ec39e04f4651cc' }
Plug 'will133/vim-dirdiff', { 'commit': '84bc8999fde4b3c2d8b228b560278ab30c7ea4c9' }

call plug#end()

" }}}
" Editor Behaviour {{{
set timeoutlen=800
set ttimeoutlen=50
set encoding=utf-8
set autoread
set matchtime=0

set tabstop=4
set softtabstop=4
set shiftwidth=4
set ai
set si
set nowrap
set expandtab
set smarttab
set incsearch
set hlsearch
set scrolloff=4

set hidden
set confirm

set ignorecase
set smartcase

set wildmenu
set wildmode=list:full
set wildignorecase

set mouse=a

if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

set autochdir

set completeopt+=noinsert,longest,menuone

autocmd FileType python setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType cpp setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType c setlocal shiftwidth=2 tabstop=2 softtabstop=2

set fileencodings=utf-8,gb18030,gbk

" Unfuck tmux

if !has('gui_running') && &term =~ '^\%(screen\|tmux\)'
  set ttymouse=sgr
  " Enable true colors, see  :help xterm-true-color
  let &termguicolors = v:true
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  " Enable bracketed paste mode, see  :help xterm-bracketed-paste
  let &t_BE = "\<Esc>[?2004h"
  let &t_BD = "\<Esc>[?2004l"
  let &t_PS = "\<Esc>[200~"
  let &t_PE = "\<Esc>[201~"

  " Enable focus event tracking, see  :help xterm-focus-event
  let &t_fe = "\<Esc>[?1004h"
  let &t_fd = "\<Esc>[?1004l"
  execute "set <FocusGained>=\<Esc>[I"
  execute "set <FocusLost>=\<Esc>[O"

  " Enable modified arrow keys, see  :help arrow_modifiers
  execute "silent! set <xUp>=\<Esc>[@;*A"
  execute "silent! set <xDown>=\<Esc>[@;*B"
  execute "silent! set <xRight>=\<Esc>[@;*C"
  execute "silent! set <xLeft>=\<Esc>[@;*D"
endif

" }}}
" UI Configuration {{{
set termguicolors
let &t_ti.="\e[2 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[2 q"
let &t_te.="\e[0 q"
set background=dark
colorscheme jellybeans
set noshowmode
set showcmd
set title
set number
set relativenumber
set cursorline
"set cursorcolumn
set showmatch
set lazyredraw

" }}}
" Keybindings {{{
noremap <C-\> :NERDTreeToggle<CR>
noremap <F1> :MundoToggle<CR>
noremap <F8> :TagbarToggle<CR>
nmap - <Plug>(choosewin)
map <Space> <Leader>
map <Leader><Space> <Leader><Leader>
noremap <C-S> :w<CR>
set pastetoggle=<F11>
nmap Y y$
nnoremap <C-p> :CtrlPMixed<CR>


" For smooth transition
inoremap <C-BS> <C-w>

inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

map <C-J> :bnext<CR>
map <C-K> :bprev<CR>

nnoremap <Leader>` :CtrlPBuffer<CR>
nnoremap <Leader>q :BD<CR>
nnoremap <Leader>o :e 
nnoremap <Leader>n :ene<CR>

nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>s :split<CR>
nnoremap <Leader>lvsa :vert sba<CR>

nnoremap <Leader>p "+p
noremap <S-Insert> "+p

" window killer
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>

" formatting shortcuts
nmap <leader>fef :call Preserve("normal gg=G")<CR>
nmap <leader>f$ :call StripTrailingWhitespace()<CR>
vmap <Leader>s :sort<CR>
nnoremap <Leader>w :w<CR>

map <Leader>tn :tabnew<CR>
map <Leader>tc :tabclose<CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" find current word in quickfix
nnoremap <leader>fw :execute "vimgrep ".expand("<cword>")." %"<cr>:copen<cr>
" find last search in quickfix
nnoremap <leader>ff :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

" Freaking Completion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

nmap <Leader>/ <Plug>CtrlSFPrompt
nmap <Leader>h :CtrlSFToggle<CR>
vmap <C-F>f <Plug>CtrlSFVwordExec

" }}}
" vim-airline {{{
let g:airline_powerline_fonts=1
let g:airline_theme='jellybeans'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#fnamecollapse=0
let g:airline#extensions#tabline#fnametruncate=0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" }}}
" Bufstop {{{
let g:BufstopAutoSpeedToggle = 1
" }}}
