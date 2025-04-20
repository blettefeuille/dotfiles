return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				highlight_overrides = {
					mocha = function(colors)
						return {
							-- Telescope UI customizations with transparent backgrounds
							TelescopePrompt = { bg = "NONE", fg = colors.mauve },
							TelescopePromptBorder = { bg = "NONE", fg = colors.mauve },
							TelescopePromptTitle = { bg = "NONE", fg = colors.lavender },

							TelescopeResults = { bg = "NONE", fg = colors.lavender },
							TelescopeResultsBorder = { bg = "NONE", fg = colors.mauve },
							TelescopeResultsTitle = { bg = "NONE", fg = colors.lavender },

							TelescopePreview = { bg = "NONE", fg = colors.lavender },
							TelescopePreviewBorder = { bg = "NONE", fg = colors.mauve },
							TelescopePreviewTitle = { bg = "NONE", fg = colors.mauve },

							-- Selection, matching, and caret
							TelescopeMatching = { fg = colors.teal, bold = true },
							TelescopeSelection = { bg = colors.mauve, fg = colors.base, bold = true },
              TelescopeSelectionCaret = { fg = colors.pink },

							-- Prefixes for prompt and caret
							TelescopePromptPrefix = { fg = colors.mauve },
							TelescopeMultiSelection = { fg = colors.lavender },
						}
					end,
				},
				integrations = {
					cmp = true,
					gitsigns = true,
					telescope = true,
					treesitter = true,
					rainbow_delimiters = true,
				},
			})
      vim.cmd.colorscheme("catppuccin")
		end,
		name = "catppuccin",
}
