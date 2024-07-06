local LAZY_NVIM_COMMIT = '6ca23c15f64e88e3ba26be9795343c4c7f2ee851'

local mod = {}

function mod.ensure_lazy()
    -- Bootstrap lazy.nvim
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    local cmd = function(arr)
        local out = vim.fn.system(arr)
        if vim.v.shell_error ~= 0 then
            vim.api.nvim_echo({
              { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
              { out, "WarningMsg" },
              { "\nPress any key to exit..." },
            }, true, {})
            vim.fn.getchar()
            os.exit(1)
        end
    end
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        cmd({'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath})
        cmd({'git', '-C', lazypath, 'checkout', '--recurse-submodules', LAZY_NVIM_COMMIT})
    end
    vim.opt.rtp:prepend(lazypath)
end

return mod
