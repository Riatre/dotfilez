-- -*- vim: set sts=2 sw=2 et fdm=marker: -------------  vim modeline -*-
-- {{{ Shorthands
local g = vim.g
local k = vim.keycode
local opt = vim.opt
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
-- }}}
g.mapleader = [[ ]]

-- Options
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
opt.autochdir = false
opt.ignorecase = true
opt.smartcase = true
if not g.vscode then
  opt.termguicolors = true
  opt.confirm = true
  opt.wildmenu = true
  opt.wildmode = "list:full"
  opt.wildignorecase = true
  opt.mouse = "a"
  opt.clipboard = 'unnamedplus'
  
  opt.undofile = true
  opt.completeopt = "menu,preview,noinsert,longest,menuone"
  opt.fileencodings = "utf-8,gb18030,gbk"
  augroup('indent', { clear = true })
  autocmd('FileType', {
    group = 'indent',
    command = 'setlocal shiftwidth=2 tabstop=2 softtabstop=2',
    pattern = { 'cpp', 'c', 'lua', 'yaml' },
  })
end

require("bootstrap").ensure_lazy()
require("lazy").setup("plugins")
require("keybindings")
