vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "Kavi-Arya/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)


-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

os.execute("python ~/.config/nvim/pywal/chadwal.py &> /dev/null &")

local autocmd = vim.api.nvim_create_autocmd

autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    require('nvchad.utils').reload()
  end
})

require('markdown-commit-reminder')
require('pandoc_convert')
require('user.autofold')
-- require('write')

local spell_group = vim.api.nvim_create_augroup("AutoSpell", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "tex", "plaintex" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
        
        -- Optional: Ensure the highlight is red undercurl
        vim.api.nvim_set_hl(0, 'SpellBad', { sp = 'red', undercurl = true })
    end,
    group = spell_group,
})
