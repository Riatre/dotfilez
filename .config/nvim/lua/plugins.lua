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
  -- Editing with popups
  'chrisbra/NrrwRgn',
  'mg979/vim-visual-multi',
  'simnalamburt/vim-mundo',
  {
    'nanotech/jellybeans.vim',
    priority = 1000,
    config = function() vim.cmd.colorscheme("jellybeans") end,
  },
  't9md/vim-choosewin',
  {'nvim-lualine/lualine.nvim', opts = {
    options = {
      theme = 'jellybeans',
      globalstatus = true,
    },
    -- tabline = {
    --   lualine_a = {{
    --       'buffers',
    --       component_separators = {},
    --       section_separators = {},
    --   }},
    --   lualine_b = {},
    --   lualine_c = {},
    --   lualine_x = {},
    --   lualine_y = {},
    --   lualine_z = {'tabs'},
    -- },
  }},
  'qpkorr/vim-bufkill',
  'majutsushi/tagbar',
  'will133/vim-dirdiff',
  'tpope/vim-eunuch',
})}
