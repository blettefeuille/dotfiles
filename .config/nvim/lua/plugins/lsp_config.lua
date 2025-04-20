return {
  -- Mason: Package manager for LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          -- LSP servers
          "pyright",          -- Python
          "lua_ls",           -- Lua
          "bashls",           -- Bash/Shell
          "dockerls",         -- Dockerfile
          "docker_compose_language_service", -- Docker Compose
          "jsonls",           -- JSON
          "yamlls",           -- YAML
        },
        automatic_installation = true,
      })

      -- Ensure linters and formatters are installed
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Python
          "black",
          "isort",
          "flake8",
          "mypy",
          -- Lua
          "stylua",
          -- Shell
          "shellcheck",
          "shfmt",
          -- YAML/JSON/etc
          "prettier",
          "yamllint",
          -- Docker
          "hadolint",
        },
        auto_update = true,
        run_on_start = true,
      })
    end,
  },

  -- null-ls for diagnostics, formatting, code actions
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

      -- Check which builtins are available before using them
      local builtins_exist = {}
      for _, source_type in ipairs({"formatting", "diagnostics", "code_actions"}) do
        builtins_exist[source_type] = {}
        if null_ls.builtins[source_type] then
          for name, _ in pairs(null_ls.builtins[source_type]) do
            builtins_exist[source_type][name] = true
          end
        end
      end

      local sources = {}

      -- Python
      table.insert(sources, null_ls.builtins.formatting.black.with({
        extra_args = { "--line-length", "88" },
      }))

      table.insert(sources, null_ls.builtins.formatting.isort.with({
        extra_args = { "--profile", "black" },
      }))
        -- Lua
      table.insert(sources, null_ls.builtins.formatting.stylua)

      table.insert(sources, null_ls.builtins.diagnostics.selene.with({
        condition = function(utils)
          return utils.root_has_file({ "selene.toml" })
        end,
      }))

      -- Docker
      table.insert(sources, null_ls.builtins.diagnostics.hadolint.with({
        filetypes = { "dockerfile" },
      }))
      -- YAML
      table.insert(sources, null_ls.builtins.formatting.prettier.with({
        filetypes = { "yaml", "yml" },
        extra_args = {
          "--parser", "yaml",
          "--tab-width", "2",
          "--print-width", "120",
        },
      }))

      table.insert(sources, null_ls.builtins.diagnostics.yamllint.with({
        filetypes = { "yaml", "yml" },
      }))

      -- JSON
      table.insert(sources, null_ls.builtins.formatting.prettier.with({
        filetypes = { "json", "jsonc" },
        extra_args = {
          "--parser", "json",
          "--tab-width", "2",
          "--print-width", "120",
        },
      }))

      -- table.insert(sources, null_ls.builtins.diagnostics.jsonlint)

      null_ls.setup({
        -- Use Mason's path for executables
        cmd_env = {
          PATH = mason_bin .. ":" .. vim.env.PATH,
        },
        sources = sources,
      })

      -- Safely setup mason-null-ls
      local success, mason_null_ls = pcall(require, "mason-null-ls")
      if success then
        mason_null_ls.setup({
          automatic_installation = true,
          automatic_setup = false,
        })
      end
    end,
  },

  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Python LSP (pyright)
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              autoImportCompletions = true,
            },
          },
        },
      })

      -- Lua LSP
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Bash Language Server
      lspconfig.bashls.setup({
        capabilities = capabilities,
        filetypes = { "sh", "bash", "zsh" },
        cmd = { "bash-language-server", "start" },
        settings = {
          bashIde = {
            globPattern = "**/*.{sh,bash,zsh}",
            includeAllWorkspaceSymbols = true,
            enableSourceErrorDiagnostics = true,
            formatOnSave = false, -- We handle formatting via null-ls
          },
        },
      })

      -- Docker
      lspconfig.dockerls.setup({
        capabilities = capabilities,
        filetypes = { "dockerfile" },
      })

      -- Docker Compose
      lspconfig.docker_compose_language_service.setup({
        capabilities = capabilities,
        filetypes = { "yaml.docker-compose", "docker-compose.yaml", "docker-compose.yml" },
        root_dir = lspconfig.util.root_pattern(
          "docker-compose.yml",
          "docker-compose.yaml",
          "compose.yml",
          "compose.yaml"
        ),
      })

      -- JSON
      local has_schemastore, schemastore = pcall(require, "schemastore")
      local json_schemas = {}
      if has_schemastore then
        json_schemas = schemastore.json.schemas()
      end

      lspconfig.jsonls.setup({
        capabilities = capabilities,
        settings = {
          json = {
            schemas = json_schemas,
            validate = { enable = true },
          },
        },
      })

      -- YAML
      local yaml_schemas = {}
      if has_schemastore then
        yaml_schemas = schemastore.yaml.schemas()
      end

      lspconfig.yamlls.setup({
        capabilities = capabilities,
        settings = {
          yaml = {
            schemas = yaml_schemas,
            validate = true,
            format = { enable = true },
            hover = true,
            completion = true,
          },
        },
      })

      -- Global keymappings for LSP
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf, noremap = true, silent = true }

          -- Core LSP functionality
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

          -- Workspace management
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)

          -- LSP restart
          vim.keymap.set("n", "<leader>lr", function()
            local clients = vim.lsp.get_active_clients({bufnr = 0})
            if clients and clients[1] then
              vim.lsp.buf_detach_client(0, clients[1].id)
            end
            vim.cmd("LspRestart")
          end, opts)

          -- Formatting
          vim.keymap.set("n", "<leader>f", function()
            vim.lsp.buf.format({
              async = true,
              filter = function(client)
                -- Prefer null-ls for formatting
                return client.name == "null-ls"
              end,
            })
          end, opts)

          -- Diagnostics
          vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
          vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },

  -- Add schemastore plugin for JSON/YAML schema support
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      -- Add icons to completion menu (optional)
      { "onsails/lspkind.nvim", optional = true },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Try to load lspkind if available
      local has_lspkind, lspkind = pcall(require, "lspkind")

      local formatting = {}
      if has_lspkind then
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        }
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip", priority = 750 },
          { name = "path", priority = 500 },
          { name = "buffer", priority = 250 },
        }),
        formatting = formatting,
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- Set up special filetype detection for docker-compose files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { "docker-compose*.yml", "docker-compose*.yaml", "compose.yml", "compose.yaml" },
        callback = function()
          vim.bo.filetype = "yaml.docker-compose"
        end,
      })
    end,
  },
}
