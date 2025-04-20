return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		-- Make sure to load nvim-web-devicons
		require("nvim-web-devicons").setup()

		vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
		vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
		vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
		vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1,
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
				},
				icon = {
					folder_empty = "󰜌",
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
						deleted = "✖", -- this can only be used in the git_status source
						renamed = "󰁕", -- this can only be used in the git_status source
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "󰄱",
						staged = "",
						conflict = "",
					},
				},
			},

			window = {
				position = "right",
				width = 40,
				mapping_options = {
					noremap = true,
					nowait = true,
				},
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = false, -- disable "nowait" so that the mapping doesn't conflict with other mappings
					},
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["l"] = "open",
					["h"] = "close_node",
					["z"] = "close_all_nodes",
					["Z"] = "expand_all_nodes",
					["R"] = "refresh",
					["a"] = {
						"add",
						config = {
							show_path = "none", -- "none", "relative", "absolute"
						},
					},
					["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
					["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
					["q"] = "close_window",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
				},
			},

			filesystem = {
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = true, -- only works on Windows for hidden files/directories
					hide_by_name = {
						--"node_modules"
					},
					hide_by_pattern = { -- uses glob style patterns
						--"*.meta",
						--"*/src/*/tsconfig.json",
					},
					always_show = { -- remains visible even if other settings would normally hide it
						--".gitignored",
					},
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						--".DS_Store",
						--"thumbs.db"
					},
					never_show_by_pattern = { -- uses glob style patterns
						--".null-ls_*",
					},
				},

				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},

				-- The renderer section defines the display behavior of file entries.
				renderer = {
					group_empty_dirs = false, -- when true, empty folders will be grouped together
					highlight_git_items = true, -- Whether to highlight git status icons
					highlight_opened_files = "none", -- "none" "icon" "name" "all", how to highlight open files
					root_folder_modifier = ":~", -- This is prepended to the root folder
					add_trailing = false, -- Add trailing slash to folder names
					indent_width = 2, -- Indent width in spaces
					indent_markers = true, -- Use indent markers instead of icons for folders
					icon_padding = " ", -- Space between icon and name
					symlink_destination = true, -- Show symlink destination
				},

				-- Setup find command to use fd instead of find when available
				find_command = "fd",

				-- The function to use when finding the root directory for a file or folder
				find_by_full_path_words = false, -- Setting to `true` will find a file searching the full path.
				search_limit = 50, -- max items to search at a time

				-- Setting to control how files are opened from Neotree
				use_libuv_file_watcher = true, -- Use Neovim's built-in file watcher to detect changes

				-- Auto-detect root directory based on git repo
				find_root_by_patterns = { ".git", "package.json", "Cargo.toml" },

				-- Function to determine the root directory
				bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
				cwd_target = {
					sidebar = "tab", -- sidebar is when position = left or right
					current = "window", -- current is when position = current
				},

				-- When set to true entering a directory will change the nvim working directory
				change_dir_on_enter = true,
			},

			buffers = {
				-- Configuration for buffer source
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
				group_empty_dirs = true, -- when true, empty folders will be grouped together
				show_unloaded = true,
			},

			git_status = {
				-- Configuration for git status source
				window = {
					position = "float",
					mappings = {
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
					},
				},
			},

			event_handlers = {
				{
					event = "neo_tree_buffer_enter",
					handler = function()
						-- Hide cursor line while in neo-tree buffer
						vim.opt_local.cursorline = false
					end,
				},
				{
					event = "file_opened",
					handler = function()
						-- Auto close the neo-tree window after selecting a file
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
		})

		-- Convenient keymaps for opensng Neotree
		vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<C-b>", ":Neotree focus<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>gs", ":Neotree float git_status<CR>", { noremap = true, silent = true })

		-- Create command to reveal current file in Neotree
		vim.api.nvim_create_user_command("NeoTreeReveal", function()
			require("neo-tree.command").execute({
				action = "focus",
				position = "right",
				reveal = true,
				reveal_force_cwd = true,
			})
		end, {})

		vim.keymap.set("n", "<leader>e", ":NeoTreeReveal<CR>", { noremap = true, silent = true })
	end,
}
