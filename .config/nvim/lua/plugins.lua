-- -*- vim: set sts=2 sw=2 et fdm=marker: -------------  vim modeline -*-
-- {{{
local vscode = vim.g.vscode

function disable_in_vscode(spec)
    for i, v in ipairs(spec) do
        if type(v) == "string" then
            spec[i] = {v, cond = not vscode}
        elseif type(v) == "table" then
            v.cond = not vscode
        end
    end
    return spec
end
-- }}}
return {
  'tpope/vim-sensible',

  -- Text editing behaviour (should be enabled anywhere)
  -- VSCode has builtin comment switch (and it does this better)
  {'tomtom/tcomment_vim', cond = not vscode},
  'tpope/vim-unimpaired',
  'tpope/vim-surround',
  'terryma/vim-expand-region',
  'b4winckler/vim-angry',
  'tommcdo/vim-exchange',
  'tpope/vim-repeat',
  'ggandor/leap.nvim',

  -- UI / Motion / IO plugins
unpack(disable_in_vscode {
  {'nanotech/jellybeans.vim',
    priority = 1000,
    config = function() vim.cmd.colorscheme("jellybeans") end,
  },
  {'nvim-lualine/lualine.nvim', opts = {
    options = {
      theme = 'jellybeans',
      globalstatus = true,
    },
  }},
  {'willothy/nvim-cokeline', -- {{{
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      show_if_buffers_are_at_least = 1,
      default_hl = {
        fg = function(buffer)
          if buffer.is_modified then
            return buffer.is_focused and '#ffffff' or '#ffb964'
          else
            return buffer.is_focused and '#d8dee9' or '#4f5b66'
          end
        end,
        bg = function(buffer)
          if buffer.is_modified then
            return buffer.is_focused and '#437019' or '#151515'
          else
            return buffer.is_focused and '#0d61ac' or '#151515'
          end
        end,
      },
      components = {
        { text = function (buffer) return ' ' .. buffer.index .. ': ' end },
        { text = function (buffer) return buffer.unique_prefix end, italic = true, fg = '#4f5b66' },
        { text = function (buffer)
            return buffer.filename .. (buffer.is_modified and '+' or '') 
          end },
        { text = ' ' },
      },
    }, -- }}}
  },
  -- Editing with popups
  'chrisbra/NrrwRgn',
  'mg979/vim-visual-multi',
  'simnalamburt/vim-mundo',
  't9md/vim-choosewin',
  'qpkorr/vim-bufkill',
  'majutsushi/tagbar',
  'will133/vim-dirdiff',
  'tpope/vim-eunuch',
})}
