local M = {}

function M.setup(lsp_config, get_root_dir)
    lsp_config.lua_ls.setup({
        root_dir = get_root_dir, -- Utilise la fonction pour déterminer le root
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false, -- Empêche l'avertissement sur third-party
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return M

