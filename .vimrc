syntax on

filetype on
filetype plugin on
filetype indent on

" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup

set tabstop=4
set softtabstop=4
set shiftwidth=4
set ai
set si
set wrap
set noexpandtab
set smarttab
set incsearch
set hlsearch

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256
" colours)
set t_Co=256

set mouse=a

set nocompatible
set number
"set cursorline
"set cursorcolumn
set scrolloff=4
set termguicolors

set background=dark

colorscheme desert

" VIM-PLUG {{{
" download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

" Some werid path for shared plugins files.
" Well at least I don't need to download plugins twice.
call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tmux-plugins/vim-tmux'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()
" }}}

" let g:airline_powerline_fonts=1
let g:airline_theme='wombat'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" vim: set foldmethod=marker :
