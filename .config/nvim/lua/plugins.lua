local PACKER_COMMIT = '1d0cf98a561f7fd654c970c49f917d74fafe1530'

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'init', install_path})
        fn.system({'git', '-C', install_path, 'remote', 'add', 'origin', 'https://github.com/wbthomason/packer.nvim'})
        fn.system({'git', '-C', install_path, 'fetch', '--depth', '1', 'origin', PACKER_COMMIT})
        fn.system({'git', '-C', install_path, 'checkout', '--recurse-submodules', FETCH_HEAD})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
local in_vscode = function()
    return vim.g.vscode ~= nil
end
local not_in_vscode = function()
    return vim.g.vscode == nil
end
local function setup_lualine()
    require('lualine').setup {
        options = {
            theme = 'jellybeans',
            globalstatus = true,
        },
        tabline = {
            lualine_a = {{
                'buffers',
                component_separators = {},
                section_separators = {},
            }},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {'tabs'},
        },
    }
end
return require('packer').startup(function(use)
    use {'wbthomason/packer.nvim', commit = PACKER_COMMIT}
    use {'tpope/vim-sensible', commit = '624c7549a5dfccef2030acc545198d102e4be1c0'}

    -- Text editing behaviour (should be enabled anywhere)
    -- VSCode has builtin comment switch (and it does this better)
    use {'tomtom/tcomment_vim', commit = 'b4930f9da28647e5417d462c341013f88184be7e', cond = not_in_vscode}
    use {'tpope/vim-unimpaired', commit = '6d44a6dc2ec34607c41ec78acf81657248580bf1'}
    use {'tpope/vim-surround', commit = '3d188ed2113431cf8dac77be61b842acb64433d9'}
    use {'terryma/vim-expand-region', commit = '966513543de0ddc2d673b5528a056269e7917276'}
    use {'b4winckler/vim-angry', commit = '08e9e9a50e6683ac7b0c1d6fddfb5f1235c75700'}
    use {'tommcdo/vim-exchange', commit = '784d63083ad7d613aa96f00021cd0dfb126a781a'}
    use {'tpope/vim-repeat', commit = '24afe922e6a05891756ecf331f39a1f6743d3d5a'}
    use {'ggandor/leap.nvim', commit = '24c0f4d08b8081022e2675fbedb59e8de325f9a6'}
    
    -- Editing with popups
    use {'chrisbra/NrrwRgn', commit = 'e027db9d94f94947153cd7b5ac9abd04371ab2b0', cond = not_in_vscode}

    -- Motion
    use {'mg979/vim-visual-multi', commit = '724bd53adfbaf32e129b001658b45d4c5c29ca1a', cond = not_in_vscode}
    
    -- UI
    use {'simnalamburt/vim-mundo', commit = 'b53d35fb5ca9923302b9ef29e618ab2db4cc675e', cond = not_in_vscode}
    use {'nanotech/jellybeans.vim', commit = 'ef83bf4dc8b3eacffc97bf5c96ab2581b415c9fa', cond = not_in_vscode}
    use {'t9md/vim-choosewin', commit = '839da609d9b811370216bdd9d4512ec2d0ac8644', cond = not_in_vscode}
    use {'nvim-lualine/lualine.nvim', commit = '0a5a66803c7407767b799067986b4dc3036e1983', cond = not_in_vscode, config = setup_lualine}
    use {'qpkorr/vim-bufkill', commit = '2bd6d7e791668ea52bb26be2639406fcf617271f', cond = not_in_vscode}
    use {'majutsushi/tagbar', commit = 'be563539754b7af22bbe842ef217d4463f73468c', cond = not_in_vscode}
    use {'will133/vim-dirdiff', commit = '84bc8999fde4b3c2d8b228b560278ab30c7ea4c9', cond = not_in_vscode}
    
    -- Misc
    use {'tpope/vim-eunuch', commit = '67f3dd32b4dcd1c427085f42ff5f29c7adc645c6', cond = not_in_vscode}
    
    if packer_bootstrap then
        require('packer').sync()
    end
end)
