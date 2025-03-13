local M = {}

function M.setup()
    local lsp_zero = require("lsp-zero")
    local lsp_config = require("lspconfig")
    local get_root_dir = require("config.get_root_dir").get_root_dir
    local lsp_lua = require("config.lsp.lsp_lua")
    local lsp_python = require("config.lsp.lsp_python")

    require("mason").setup({})
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "pyright",
        },
        handlers = {
            function(server_name)
                lsp_config[server_name].setup({
                    root_dir = get_root_dir,
                })
            end,
            lua_ls = function()
                lsp_lua.setup(lsp_config, get_root_dir)
            end,
            pyright = function()
                lsp_python.setup(lsp_config, get_root_dir)
            end,
        }
    })
    lsp_zero.on_attach(function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        local keymap = vim.keymap.set

        keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
        keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
        keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    end)
end

return M

