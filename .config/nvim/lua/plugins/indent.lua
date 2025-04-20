return {
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = "BufReadPre",
		opts = {
			-- Visually appealing symbols (choose one):
			symbol = "│", -- Clean solid line (best readability)
			-- symbol = "▏",  -- Thin vertical bar (more subtle)
			-- symbol = "┆",  -- Dashed line (good balance)

			options = { try_as_border = true },
			draw = {
				delay = 10,
				animation = function(total_steps, current_step)
					return current_step / total_steps -- Linear progression
				end,
			},
		},
		config = function(_, opts)
			-- Single Catppuccin Mocha color (blue) for all scopes
			local mocha = require("catppuccin.palettes").get_palette("mocha")
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", {
				fg = mocha.lavender, -- Using Catppuccin's blue
				nocombine = true, -- Prevents color blending
			})

			require("mini.indentscope").setup(opts)
		end,
	},
}
