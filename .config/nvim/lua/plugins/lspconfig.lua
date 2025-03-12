return {
    {
       "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
             "neovim/nvim-lspconfig",
             "williamboman/mason.nvim",
             "williamboman/mason-lspconfig.nvim",
             "hrsh7th/nvim-cmp",
             "hrsh7th/cmp-nvim-lsp",
             "L3MON4D3/LuaSnip",
             "onsails/lspkind.nvim"
        },
        -- your other configurations
        config = function()
            local lsp_zero = require("lsp-zero")
            local lsp_config = require("lspconfig")
            local cmp = require("cmp")
            local lsp_kind = require("lspkind")

            -- Import the custom root dir logic
            local get_root_dir = require("config.get_root_dir")
            -- Import Lua LSP configuration
            local lsp_lua = require("config.lsp.lsp_lua")

            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require("mason").setup({})
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                },
                handlers = {
                    -- default handler, apply to every language server without
                    -- a custom handler
                    function(server_name)
                        lsp_config[server_name].setup({
                            root_dir = get_root_dir.get_root_dir(), -- Add root_dir logic
                        })
                    end,

                    -- Lua LSP setup
                    lua_ls = function()
                        lsp_lua.setup(get_root_dir.get_root_dir()) -- Pass root_dir to Lua LSP setup
                    end,
                }
            })
            lsp_zero.set_sign_icons({
                    error = "",
                    warn = "",
                    hint = "",
                    info = "",
            })
            -- auto-completion configuration
            cmp.setup({
                sources = {
                    { name = "nvim_lsp" }
                },
                formatting = {
                    format = lsp_kind.cmp_format({
                        mode = "symbol_text",
                        max_width = 50,
                    })
                },
            })
        end
    }
}

