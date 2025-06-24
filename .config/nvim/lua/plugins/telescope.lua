return {
	"nvim-telescope/telescope.nvim",
	lazy = false,
	cmd = "Telescope", -- Lazy load when calling Telescope
	dependencies = {
		{ "nvim-lua/plenary.nvim" }, -- Required dependency
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- Fast searching
		{ "nvim-telescope/telescope-ui-select.nvim" }, -- Better UI select
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		-- Function to find git root or fall back to opened directory
		local function find_git_root_or_cwd()
			local current_file = vim.api.nvim_buf_get_name(0)
			local current_dir = current_file == "" and vim.loop.cwd() or vim.fn.fnamemodify(current_file, ":h")
			local root_dir = vim.fs.find(".git", { path = current_dir, upward = true })[1]
			if root_dir then
				return vim.fn.fnamemodify(root_dir, ":h")
			end
			return vim.loop.cwd()
		end

		telescope.setup({
			defaults = {
				prompt_prefix = "🔍 ",
				selection_caret = "› ",
				path_display = { "smart" },
				borderchars = {
					prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					preview = { "═", "║", "═", "║", "╔", "╗", "╝", "╚" },
				},
				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next, -- Next search history
						["<C-p>"] = actions.cycle_history_prev, -- Previous search history
						["<C-j>"] = actions.move_selection_next, -- Move down
						["<C-k>"] = actions.move_selection_previous, -- Move up
						["<C-s"] = actions.select_vertical, -- Open in vertical split
						["<C-x>"] = actions.select_horizontal, -- Open in horizontal split
						["<C-t>"] = actions.select_tab, -- Open in new tab
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- Send to Quickfix list
						["<Esc>"] = actions.close, -- Close Telescope
						["<C-c>"] = actions.close,
					},
					n = {
						["q"] = actions.close,
					},
				},
				cwd = find_git_root_or_cwd(), -- Set default cwd
			},
			pickers = {
				find_files = {
					hidden = true, -- Show hidden files
					cwd = find_git_root_or_cwd(), -- Use git root or opened dir for find_files
				},
				live_grep = {
					only_sort_text = true, -- Grep text only, ignore filenames
					cwd = find_git_root_or_cwd(), -- Use git root or opened dir for live_grep
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		-- Load extensions
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		-- Keymaps for launching Telescope
		local keymap = vim.keymap.set
		keymap("n", "<leader>ff", function()
			builtin.find_files({ cwd = find_git_root_or_cwd() })
		end, { desc = "🔍 Find Files" })

		keymap("n", "<leader>fg", function()
			builtin.live_grep({ cwd = find_git_root_or_cwd() })
		end, { desc = "🔎 Live Grep" })

		keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "📂 Open Buffers" })
		keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "📖 Help Tags" })
		keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "⏳ Recent Files" })
		keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "🛠 Commands" })

		-- LSP Keymaps
		keymap("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "📄 Document Symbols" })
		keymap("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "📁 Workspace Symbols" })
		keymap("n", "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", { desc = "➡️ Go to Definition" })
		keymap("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>", { desc = "🔗 References" })
		keymap("n", "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", { desc = "⚙️ Implementations" })
		keymap("n", "<leader>ft", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "📐 Type Definitions" })
		keymap("n", "<leader>fn", ":Telescope notify<CR>", { noremap = true, silent = true })
	end,
}
