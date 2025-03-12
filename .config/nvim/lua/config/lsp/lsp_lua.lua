-- lua/config/lsp/lsp_lua.lua
local M = {}

function M.setup(root_dir)
    local lsp_config = require("lspconfig")

    lsp_config.lua_ls.setup({
        root_dir = root_dir,  -- Pass the root_dir here
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" }
                }
            }
        }
    })
end

return M

