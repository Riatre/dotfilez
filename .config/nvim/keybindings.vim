nmap Y y$

nnoremap <Leader>p "+p
noremap <S-Insert> "+p

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" formatting shortcuts
vmap <Leader>s :sort<CR>

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

noremap <C-S> :w<CR>
nnoremap <Leader>w :w<CR>

if exists('g:vscode')
    nnoremap <Leader>v :Vsplit<CR>
    nnoremap <Leader>s :Split<CR>
    nnoremap <Leader>q <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
else
    noremap <F1> :MundoToggle<CR>
    noremap <F8> :TagbarToggle<CR>
    nmap - <Plug>(choosewin)

    nnoremap <Leader>o :e 
    nnoremap <Leader>n :ene<CR>
    nnoremap <Leader>v :vsplit<CR>
    nnoremap <Leader>s :split<CR>
    nnoremap <Leader>lvsa :vert sba<CR>

    " find current word in quickfix
    nnoremap <leader>fw :execute "vimgrep ".expand("<cword>")." %"<cr>:copen<cr>
    " find last search in quickfix
    nnoremap <leader>ff :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>
    nnoremap <C-P> <cmd>Telescope find_files<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>

    " Freaking Completion
    inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " window killer
    nnoremap <silent> Q :lua CloseWindowOrKillBuffer()<cr>

    map <C-J> :bnext<CR>
    map <C-K> :bprev<CR>

    nnoremap <Leader>q :BD<CR>

    map <Leader>tn :tabnew<CR>
    map <Leader>tc :tabclose<CR>
endif
