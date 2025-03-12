-- lua/config/keymaps.lua
local M = {}

function M.setup()
  local keymap = vim.keymap.set

  -- Colorscheme (unchanged)
  keymap("n", "<leader>ct", "<cmd>lua require('config.colorscheme').set_theme(vim.fn.input('Theme: '))<CR>", { desc = "Change theme" })
  keymap("n", "<leader>cd", function()
    local theme = vim.fn.input('New default theme: ')
    require('config.colorscheme').set_default_theme(theme)
  end, { desc = "Change default theme" })

  -- Save and quit
  keymap("n", "<leader>w", ":update<CR>", { desc = "Save file" })
  keymap("n", "<leader>q", ":quit<CR>", { desc = "Quit window" })
  keymap("n", "<leader>x", ":qa<CR>", { desc = "Quit all" })

  -- Move to start/end of line
  keymap("n", "H", "^", { desc = "Move to start of line" })
  keymap("n", "L", "$", { desc = "Move to end of line" })

  -- Scroll down/up and center cursor
  keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
  keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

  -- Auto-paste toggle keymap
  keymap("n", "<F2>", ":set paste!<CR>", { desc = "Toggle paste mode" })

  -- Keymap to copy to clipboard in visual mode
  keymap("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })

  -- Disable delete and copy (these keymaps will be disabled in normal mode)
  keymap("n", "d", "<Nop>", { desc = "Disable delete" })
  keymap("n", "y", "<Nop>", { desc = "Disable copy" })
end

return M

