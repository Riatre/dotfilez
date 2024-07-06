local vscode = vim.g.vscode

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

    -- Editing with popups
    {'chrisbra/NrrwRgn', cond = not vscode},

    -- Motion
    {'mg979/vim-visual-multi', cond = not vscode},

    -- UI
    {'simnalamburt/vim-mundo', cond = not vscode},
    {'nanotech/jellybeans.vim', priority = 1000, cond = not vscode},
    {'t9md/vim-choosewin', cond = not vscode},
    {'nvim-lualine/lualine.nvim', cond = not vscode, opts = {
        options = {
            theme = 'jellybeans',
            globalstatus = true,
        },
        -- tabline = {
        --     lualine_a = {{
        --         'buffers',
        --         component_separators = {},
        --         section_separators = {},
        --     }},
        --     lualine_b = {},
        --     lualine_c = {},
        --     lualine_x = {},
        --     lualine_y = {},
        --     lualine_z = {'tabs'},
        -- },
    }},
    {'qpkorr/vim-bufkill', cond = not vscode},
    {'majutsushi/tagbar', cond = not vscode},
    {'will133/vim-dirdiff', cond = not vscode},

    -- Misc
    {'tpope/vim-eunuch', cond = not vscode},
}
