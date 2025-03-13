return {
    'nvim-treesitter/nvim-treesitter',
    ft = { 'c', 'cpp', 'go', 'lua', 'rust' },
    build = ':TSUpdate',
    config = function()
        require("config.treesitter_config").setup()
    end
}
