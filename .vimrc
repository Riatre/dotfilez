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
  silent! execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

" Some werid path for shared plugins files.
call plug#begin('~/.vim/plugged')

" Polyfill
if !has('nvim') 
  Plug 'tpope/vim-sensible'
  " Plug 'roxma/vim-hug-neovim-rpc'
endif

" UI
Plug 'tmux-plugins/vim-tmux'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nanotech/jellybeans.vim'
Plug 't9md/vim-choosewin'
Plug 'qpkorr/vim-bufkill'
Plug 'mihaifm/bufstop'
Plug 'majutsushi/tagbar'
Plug 'Shougo/denite.nvim'
Plug 'scrooloose/nerdtree'

" Basic Editing
Plug 'simnalamburt/vim-mundo'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-unimpaired'
Plug 'easymotion/vim-easymotion'
Plug 'chrisbra/NrrwRgn'
Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'

" Nice to have
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'dyng/ctrlsf.vim'
Plug 'will133/vim-dirdiff'

" Languages
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
endif
Plug 'honza/vim-snippets'
Plug 'scrooloose/syntastic', { 'on': [] }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

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
" }}}
" UI Configuration {{{
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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
nnoremap <C-p> :Denite file_rec<CR>
nnoremap <Leader>/ :Denite grep:.<CR>


" For smooth transition
inoremap <C-BS> <C-w>

inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

map <C-J> :bnext<CR>
map <C-K> :bprev<CR>

nnoremap <Leader>` :Denite buffer<CR>
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

nmap <Leader>g <Plug>CtrlSFPrompt
nmap <Leader>h :CtrlSFToggle<CR>
vmap <C-F>f <Plug>CtrlSFVwordExec

" }}}
" Syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{syntasticstatuslineflag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_error_symbol = '✗'
let g:syntastic_style_error_symbol = '✠'
let g:syntastic_warning_symbol = '∆'
let g:syntastic_style_warning_symbol = '≈'
" }}}
" EasyMotion {{{1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-overwin-f2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

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
