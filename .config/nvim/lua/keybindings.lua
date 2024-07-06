-- -*- vim: set sts=2 sw=2 et fdm=marker: -------------  vim modeline -*-
-- {{{
function map(mode, seq, command, args)
  args = args or { silent = true, noremap = true }
  vim.api.nvim_set_keymap(mode, seq, command, args)
end

function CloseWindowOrKillBuffer()
  -- Get the current buffer number
  local current_buf = vim.api.nvim_get_current_buf()

  -- Count the number of windows associated with the current buffer
  local number_of_windows_to_this_buffer = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == current_buf then
      number_of_windows_to_this_buffer = number_of_windows_to_this_buffer + 1
    end
  end

  -- Get the current buffer name
  local current_buf_name = vim.api.nvim_buf_get_name(current_buf)

  -- Check if the buffer name contains 'NERD'
  if string.find(current_buf_name, 'NERD') then
    vim.cmd('wincmd c')
    return
  end

  -- Close the window if more than one window is associated with the buffer
  if number_of_windows_to_this_buffer > 1 then
    vim.cmd('wincmd c')
  else
    vim.cmd('bdelete')
  end
end
-- }}}
require('leap').add_default_mappings()

-- Run out of time for learning Neovim APIs
local cfg = vim.fn.stdpath('config') .. '/'
vim.cmd.source(cfg .. "keybindings.vim")

if vim.g.vscode then
  -- Use VSCode builtin comment instead of tomtom/tcomment_vim
  map('x', 'gc', '<Plug>VSCodeCommentary')
  map('n', 'gc', '<Plug>VSCodeCommentary')
  map('o', 'gc', '<Plug>VSCodeCommentary')
  map('n', 'gcc', '<Plug>VSCodeCommentaryLine')
end
