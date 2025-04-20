require("core.options").set_options()
require("core.keymaps").setup()
require("core.lazy").setup_lazy()

-- Setup plugins
local opts = {}
local plugins = {
	{ import = "plugins" },
}
require("lazy").setup(plugins, opts)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
	pattern = "*",
	command = "checktime",
})
