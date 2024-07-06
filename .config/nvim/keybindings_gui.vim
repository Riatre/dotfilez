noremap <F1> :MundoToggle<CR>
noremap <F8> :TagbarToggle<CR>
nmap - <Plug>(choosewin)

noremap <C-S> :w<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>o :e 
nnoremap <Leader>n :ene<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>s :split<CR>
nnoremap <Leader>lvsa :vert sba<CR>

" For smooth transition
inoremap <C-BS> <C-w>

set pastetoggle=<F11>

" find current word in quickfix
nnoremap <leader>fw :execute "vimgrep ".expand("<cword>")." %"<cr>:copen<cr>
" find last search in quickfix
nnoremap <leader>ff :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

" Freaking Completion
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" window killer
nnoremap <silent> Q :lua CloseWindowOrKillBuffer()<cr>

inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

map <C-J> :bnext<CR>
map <C-K> :bprev<CR>

nnoremap <Leader>q :BD<CR>

map <Leader>tn :tabnew<CR>
map <Leader>tc :tabclose<CR>
