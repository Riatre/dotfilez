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
" Plug 'itchyny/lightline.vim'
" Plug 'bling/vim-bufferline'
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
Plug 'nanotech/jellybeans.vim'
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
colorscheme jellybeans
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
" " Statusline & Tabline (lightline) {{{1
" set noshowmode
" set showtabline=2

" let g:bufferline_echo = 0
" let g:bufferline_active_buffer_left = ''
" let g:bufferline_active_buffer_right = ''
" let g:bufferline_excludes = ['vimfiler']

" let g:lightline = {
"       \ 'enable': { 'statusline': 1, 'tabline': 1 },
"       \ 'tabline': {
"       \   'left': [ [ 'bufferline' ] ]
"       \ },
"       \ 'mode_map': { 'c': 'NORMAL' },
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
"       \ },
"       \ 'colorscheme': 'jellybeans',
"       \ 'component_function': {
"       \   'modified': 'LightLineModified',
"       \   'readonly': 'LightLineReadonly',
"       \   'fugitive': 'LightLineFugitive',
"       \   'filename': 'LightLineFilename',
"       \   'fileformat': 'LightLineFileformat',
"       \   'filetype': 'LightLineFiletype',
"       \   'fileencoding': 'LightLineFileencoding',
"       \   'mode': 'LightLineMode',
"       \ },
"       \ 'component_expand': {
"       \   'bufferline': 'LightlineBufferline',
"       \ },
"       \ 'component_type': {
"       \   'bufferline': 'tabsel',
"       \ },
"       \ 'separator': { 'left': '', 'right': '' },
"       \ 'subseparator': { 'left': '', 'right': '' },
"       \ 'tabline_separator': { 'left': '', 'right': '' },
"       \ 'tabline_subseparator': { 'left': '', 'right': '' }
"       \ }

" function! LightlineBufferline()
"   call bufferline#refresh_status()
"   return [ g:bufferline_status_info.before, g:bufferline_status_info.current, g:bufferline_status_info.after]
" endfunction

" function! LightLineModified()
"   return &ft =~ 'help\|vimfiler\|mundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
" endfunction

" function! LightLineReadonly()
"   return &ft !~? 'help\|vimfiler\|mundo' && &readonly ? '' : ''
" endfunction

" function! LightLineFilename()
"   return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
"         \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
"         \  &ft == 'unite' ? unite#get_status_string() :
"         \  &ft == 'vimshell' ? vimshell#get_status_string() :
"         \ expand('%:t') =~ '__Mundo\|NERD_tree' ? '' :
"         \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
"         \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
" endfunction

" function! LightLineFugitive()
"   if &ft !~? 'vimfiler\|Mundo' && exists("*fugitive#head")
"     let branch = fugitive#head()
"     return branch !=# '' ? '⭠ '.branch : ''
"   endif
"   return ''
" endfunction

" function! LightLineFileformat()
"   return winwidth(0) > 70 ? &fileformat : ''
" endfunction

" function! LightLineFiletype()
"   return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
" endfunction

" function! LightLineFileencoding()
"   return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
" endfunction

" function! LightLineMode()
"   let fname = expand('%:t')
"   return fname == '__Tagbar__' ? 'Tagbar' :
"         \ fname == 'ControlP' ? 'CtrlP' :
"         \ fname == '__Mundo__' ? 'Mundo' :
"         \ fname == '__Mundo_Preview__' ? 'Mundo Preview' :
"         \ fname =~ 'NERD_tree' ? 'NERDTree' :
"         \ &ft == 'unite' ? 'Unite' :
"         \ &ft == 'vimfiler' ? 'VimFiler' :
"         \ &ft == 'vimshell' ? 'VimShell' :
"         \ winwidth(0) > 60 ? lightline#mode() : ''
" endfunction

" " }}}
" vim-airline (deprecated) {{{
let g:airline_powerline_fonts=1
let g:airline_theme='jellybeans'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" }}}
" vim: set foldmethod=marker :

