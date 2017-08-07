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
if empty(glob("~/.config/nvim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fLo ~/.config/nvim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
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
Plug 'scrooloose/syntastic', { 'on': [] }

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
Plug 'mihaifm/bufstop'
Plug 'qpkorr/vim-bufkill'
Plug 'terryma/vim-expand-region'
Plug 'chrisbra/NrrwRgn'
Plug 'pangloss/vim-javascript'
Plug 'kchmck/vim-coffee-script'
Plug 'mileszs/ack.vim'
Plug 'zchee/deoplete-jedi'
Plug 'racer-rust/vim-racer'
Plug 'Shougo/neoinclude.vim'
Plug 'will133/vim-dirdiff'

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

if !has('nvim') 
  Plug 'tpope/vim-sensible'
endif

augroup load_on_insert
  autocmd!
  autocmd InsertEnter * call deoplete#enable() 
        \ | autocmd! load_on_insert
augroup END

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

autocmd BufEnter * lcd %:p:h

set completeopt+=noinsert,longest,menuone
" }}}
" UI Configuration {{{
set background=dark
colorscheme jellybeans
set termguicolors
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
noremap <C-\> :VimFilerExplorer<CR>
noremap <F1> :MundoToggle<CR>
nmap - <Plug>(choosewin)
map <Space> <Leader>
map <Leader><Space> <Leader><Leader>
noremap <C-S> :w<CR>
set pastetoggle=<F11>
nmap Y y$
nnoremap <C-p> :Unite file_rec/async<CR>
nnoremap <Leader>/ :Unite grep:.<CR>


" For smooth transition
inoremap <C-BS> <C-w>

inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

map <C-J> :bnext<CR>
map <C-K> :bprev<CR>

nnoremap <Leader>` :Unite -quick-match buffer<CR>
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

nnoremap <Leader>g :Ack! 

" }}}
" syntastic {{{
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
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

if executable('ag')
    let g:unite_source_rec_async_command = 'ag --nocolor --nogroup --hidden -g ""'
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '--nocolor --nogroup --hidden'
    let g:unite_source_grep_recursive_opt=''
endif
