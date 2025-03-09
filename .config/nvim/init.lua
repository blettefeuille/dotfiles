vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader= " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local opts = {}
local plugins = {
  { import = "plugins" },
}

require("lazy").setup(plugins, opts)

-- THEMES
local colorscheme = require("config.colorscheme")
colorscheme.set_theme()
vim.keymap.set("n", "<leader>ct", "<cmd>lua require('config.colorscheme').set_theme(vim.fn.input('Theme: '))<CR>")
vim.keymap.set('n', '<leader>cd', function()
  local theme = vim.fn.input('New default theme: ')
  require('config.colorscheme').set_default_theme(theme)
end, { desc = '[C]hange [D]efault theme' })

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

