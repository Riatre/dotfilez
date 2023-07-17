local g = vim.g
g.mapleader = [[ ]]

-- Options
local opt = vim.opt
opt.showmode = false
opt.showcmd = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.showmatch = true
opt.lazyredraw = true
opt.timeoutlen = 800
opt.ttimeoutlen = 50
opt.encoding = "utf-8"
opt.background = "dark"
opt.autoread = true
opt.matchtime = 0
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.ai = true
opt.si = true
opt.expandtab = true
opt.smarttab = true
opt.incsearch = true
opt.hlsearch = true
opt.scrolloff = 4
opt.hidden = true
opt.autochdir = true
opt.ignorecase = true
opt.smartcase = true
if not g.vscode then
  opt.confirm = true
  opt.wildmenu = true
  opt.wildmode = "list:full"
  opt.wildignorecase = true
  opt.mouse = "a"
  
  opt.undodir = ".undodir/nvim/"
  opt.undofile = true
  opt.completeopt = "menu,preview,noinsert,longest,menuone"
  opt.fileencodings = "utf-8,gb18030,gbk"
end

if not g.vscode then
  vim.cmd [[
    autocmd FileType python setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType cpp setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType c setlocal shiftwidth=2 tabstop=2 softtabstop=2
  ]]
end

-- Commands
local create_cmd = vim.api.nvim_create_user_command
create_cmd('PackerInstall', function()
  vim.cmd [[packadd packer.nvim]]
  require('plugins').install()
end, {})
create_cmd('PackerUpdate', function()
  vim.cmd [[packadd packer.nvim]]
  require('plugins').update()
end, {})
create_cmd('PackerSync', function()
  vim.cmd [[packadd packer.nvim]]
  require('plugins').sync()
end, {})
create_cmd('PackerClean', function()
  vim.cmd [[packadd packer.nvim]]
  require('plugins').clean()
end, {})
create_cmd('PackerCompile', function()
  vim.cmd [[packadd packer.nvim]]
  require('plugins').compile()
end, {})

-- Keybindings
function map(mode, seq, command, args)
  args = args or { silent = true, noremap = true }
  vim.api.nvim_set_keymap(mode, seq, command, args)
end

-- Use VSCode builtin comment instead of tomtom/tcomment_vim
if g.vscode then
  map('x', 'gc', '<Plug>VSCodeCommentary')
  map('n', 'gc', '<Plug>VSCodeCommentary')
  map('o', 'gc', '<Plug>VSCodeCommentary')
  map('n', 'gcc', '<Plug>VSCodeCommentaryLine')
end

require('leap').add_default_mappings()

-- Run out of time for learning Neovim APIs
vim.cmd [[
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
]]

if g.vscode then
  vim.cmd [[
    noremap <C-S> :Write<CR>
    nnoremap <Leader>w :Write<CR>

    nnoremap <Leader>v :Vsplit<CR>
    nnoremap <Leader>s :Split<CR>
    nnoremap <Leader>q <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
    set clipboard=unnamedplus
  ]]
else
  vim.cmd [[
    set termguicolors
    colorscheme jellybeans
    noremap <C-\> :NERDTreeToggle<CR>
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

    nmap <Leader>g <Plug>CtrlSFPrompt
    nmap <Leader>h :CtrlSFToggle<CR>
    vmap <C-F>f <Plug>CtrlSFVwordExec

    " window killer
    nnoremap <silent> Q :call CloseWindowOrKillBuffer()<cr>

    inoremap <A-h> <Left>
    inoremap <A-j> <Down>
    inoremap <A-k> <Up>
    inoremap <A-l> <Right>

    map <C-J> :bnext<CR>
    map <C-K> :bprev<CR>

    nnoremap <Leader>q :BD<CR>

    map <Leader>tn :tabnew<CR>
    map <Leader>tc :tabclose<CR>
  ]]
end
