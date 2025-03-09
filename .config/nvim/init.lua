-- Load core configuration
require('config.options').set_options()
require('config.lazy').setup_lazy()

-- Setup plugins
local opts = {}
local plugins = {
  { import = "plugins" },
}

require("lazy").setup(plugins, opts)

-- Load remaining configuration
require('config.colorscheme').set_theme()
require('config.keymaps').set_keymaps()
