" -*- vim: set sts=2 sw=2 et fdm=marker: -------------  vim modeline -*-
set nocompatible

" vim-plug {{{

" download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

" Some werid path for shared plugins files.
call plug#begin('~/.config/nvim/plugged')

Plug 'tmux-plugins/vim-tmux'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'honza/vim-snippets'
Plug 'scrooloose/syntastic'
Plug 'simnalamburt/vim-mundo'
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-eunuch'
Plug 'majutsushi/tagbar'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler.vim', { 'on': 'VimFilerExplorer' }
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 't9md/vim-choosewin'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-sensible'

call plug#end()

" }}}
" Editor Behaviour {{{
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
set number
set cursorline
"set cursorcolumn
set scrolloff=4

set showcmd
set hidden
set confirm
set title

set ignorecase
set smartcase

set mouse=a

if has("persistent_undo")
  set undodir=~/.undodir/
  set undofile
endif

autocmd BufEnter * lcd %:p:h
" }}}
" Color Scheme {{{
set background=dark
colorscheme desert
set termguicolors
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" }}}
" Keybindings {{{
noremap <C-\> :VimFilerExplorer<CR>
noremap <F1> :MundoToggle<CR>
nmap - <Plug>(choosewin)
map <Space> <Leader>
map <Leader><Space> <Leader><Leader>
noremap <C-S> :w<CR>
set pastetoggle=<F11>
nmap Y y$
" For smooth transition
inoremap <C-BS> <C-w>

inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>
" }}}
" Undotree {{{
let g:undotree_SetFocusWhenToggle = 1
" }}}
" vim-airline {{{
let g:airline_powerline_fonts=1
let g:airline_theme='wombat'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" }}}
" Syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
" }}}
" EasyMotion {{{1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-overwin-f)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" }}}
" vimfiler {{{
let g:vimfiler_as_default_explorer = 1
" }}}

" vim: set foldmethod=marker :

