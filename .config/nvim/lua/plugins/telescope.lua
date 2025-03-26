return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = require("config.telescope_config").opts,
    keys = require("config.telescope_config").keys
}
