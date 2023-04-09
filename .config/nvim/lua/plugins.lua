local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
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
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'tpope/vim-sensible'

    -- Text editing behaviour (should be enabled anywhere)
    -- VSCode has builtin comment switch (and it does this better)
    use {'tomtom/tcomment_vim', cond = not_in_vscode}
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-surround'
    use 'terryma/vim-expand-region'
    use 'b4winckler/vim-angry'
    use 'tommcdo/vim-exchange'
    use 'tpope/vim-repeat'
    use 'ggandor/leap.nvim'
    
    -- Editing with popups
    use {'chrisbra/NrrwRgn', cond = not_in_vscode}

    -- Motion
    use {'terryma/vim-multiple-cursors', cond = not_in_vscode}
    
    -- UI
    use {'simnalamburt/vim-mundo', cond = not_in_vscode}
    use {'nanotech/jellybeans.vim', cond = not_in_vscode}
    use {'t9md/vim-choosewin', cond = not_in_vscode}
    use {'vim-airline/vim-airline', cond = not_in_vscode}
    use {'vim-airline/vim-airline-themes', cond = not_in_vscode}
    use {'qpkorr/vim-bufkill', cond = not_in_vscode}
    use {'majutsushi/tagbar', cond = not_in_vscode}
    use {'will133/vim-dirdiff', cond = not_in_vscode}
    
    -- Misc
    use {'tpope/vim-eunuch', cond = not_in_vscode}
    
    if packer_bootstrap then
        require('packer').sync()
    end
end)
