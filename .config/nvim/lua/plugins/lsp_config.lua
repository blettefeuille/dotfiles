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
					"pyright", -- Python
					"lua_ls", -- Lua
					"bashls", -- Bash/Shell
					"dockerls", -- Dockerfile
					"docker_compose_language_service", -- Docker Compose
					"jsonls", -- JSON
					"yamlls", -- YAML
					"texlab",
					"rust_analyzer", -- Rust
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
					-- Rust
					"rustfmt",
					-- LaTeX
					"latexindent",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
	-- Conform for formatting
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					rust = { "rustfmt" },
					python = { "black", "isort" },
					lua = { "stylua" },
					sh = { "shfmt" },
					yaml = { "prettier" },
					json = { "prettier" },
					tex = { "latexindent" },
					["yaml.docker-compose"] = { "prettier" },
				},
				format_on_save = {
					-- Enabling format on save with timeout
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})

			-- Set keymapping for formatting
			vim.keymap.set("n", "<leader>f", function()
				require("conform").format({
					async = true,
					lsp_fallback = true,
				})
			end, { noremap = true, silent = true })
		end,
	},

	-- null-ls for diagnostics, code actions
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

			local sources = {
				-- Python diagnostics

				-- Lua diagnostics
				null_ls.builtins.diagnostics.selene.with({
					condition = function(utils)
						return utils.root_has_file({ "selene.toml" })
					end,
				}),

				-- Docker diagnostics
				null_ls.builtins.diagnostics.hadolint.with({
					filetypes = { "dockerfile" },
				}),

				-- YAML diagnostics
				null_ls.builtins.diagnostics.yamllint.with({
					filetypes = { "yaml", "yml", "yaml.docker-compose" },
				}),
			}

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

			-- Rust Analyzer with no_std support
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						cargo = {
							buildScripts = {
								enable = true,
							},
							-- Enable fetching dependencies for better code navigation
							loadOutDirsFromCheck = true,
							allTargets = true,
						},
						checkOnSave = {
							command = "clippy",
							extraArgs = { "--target-dir", "target/analyzer" },
						},
						procMacro = {
							enable = true,
							ignored = {
								-- Add any proc macros causing issues
							},
						},
						-- Support for no_std development
						assist = {
							importGranularity = "module",
							importPrefix = "self",
						},
						diagnostics = {
							disabled = { "unresolved-proc-macro" },
							-- Enable experimental features as needed
							experimentalDecorator = true,
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
			-- LaTeX Configuration
			lspconfig.texlab.setup({
				capabilities = capabilities,
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = true,
						},
						forwardSearch = {
							executable = "zathura", -- or your preferred PDF viewer
							args = { "--synctex-forward", "%l:1:%f", "%p" },
						},
						lint = {
							onChange = true,
						},
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
						local clients = vim.lsp.get_active_clients({ bufnr = 0 })
						if clients and clients[1] then
							vim.lsp.buf_detach_client(0, clients[1].id)
						end
						vim.cmd("LspRestart")
					end, opts)

					-- Diagnostics
					vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
					vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts)
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

	-- lspkind for completion menu icons
	{
		"onsails/lspkind.nvim",
		lazy = false,
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
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- Catppuccin Mocha Lavender color
			local catppuccin_lavender = "#b4befe"

			-- Define bordered window style with Catppuccin Mocha Lavender
			local border_opts = {
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			}

			-- Set highlight for borders to Catppuccin lavender
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = catppuccin_lavender })

			-- Setup Markdown rendering highlights for documentation
			vim.api.nvim_set_hl(0, "CmpDocumentationBold", { bold = true })
			vim.api.nvim_set_hl(0, "CmpDocumentationItalic", { italic = true })
			vim.api.nvim_set_hl(0, "CmpDocumentationCodeBlock", { fg = "#89b4fa", bg = "#313244" })
			vim.api.nvim_set_hl(0, "CmpDocumentationLink", { fg = "#89dceb", underline = true })

			-- Create function to handle markdown syntax in documentation
			local function markdown_format(content)
				if not content or content == "" then
					return content
				end
			end

			-- Configure cmp
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
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						symbol_map = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "",
						},
						before = function(entry, vim_item)
							vim_item.menu = ({
								nvim_lsp = "[LSP]",
								luasnip = "[Snippet]",
								buffer = "[Buffer]",
								path = "[Path]",
							})[entry.source.name]
							return vim_item
						end,
					}),
				},
				window = {
					completion = cmp.config.window.bordered(border_opts),
					documentation = {
						max_height = 15,
						max_width = 60,
						border = border_opts.border,
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					},
				},
				experimental = {
					ghost_text = true,
				},
			})

			-- Create custom documentation window formatter
			cmp.event:on("open_documentation_window", function()
				vim.api.nvim_create_autocmd("FileType", {
					pattern = "cmp_docs",
					callback = function()
						vim.opt_local.conceallevel = 2
						vim.opt_local.concealcursor = "niv"
						vim.opt_local.wrap = true
						vim.opt_local.linebreak = true

						-- Apply Markdown syntax to the documentation buffer
						local buf = vim.api.nvim_get_current_buf()
						local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
						local formatted_content = {}

						for _, line in ipairs(content) do
							table.insert(formatted_content, markdown_format(line))
						end

						if #formatted_content > 0 then
							vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_content)
						end
					end,
				})
			end)

			-- Use buffer source for `/` and `?`
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
				window = {
					completion = cmp.config.window.bordered(border_opts),
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
				window = {
					completion = cmp.config.window.bordered(border_opts),
				},
			})

			-- Set up special filetype detection for docker-compose files
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = { "docker-compose*.yml", "docker-compose*.yaml", "compose.yml", "compose.yaml" },
				callback = function()
					vim.bo.filetype = "yaml.docker-compose"
				end,
			})

			-- Set up proper markdown filetype detection for documentation windows
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "cmp-doc",
				callback = function()
					vim.bo.filetype = "markdown"
				end,
			})
		end,
	},
}
