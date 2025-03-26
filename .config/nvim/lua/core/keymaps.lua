-- lua/config/keymaps.lua
local M = {}

-- Define default options for keybindings
local opts = { noremap = true, silent = true }

-- Define keybindings in a table
local keymaps = {
  -- Save and quit
  {
    mode = "n",
    key = "<leader>w",
    action = ":update<CR>",
    desc = "Save file",
    opts = opts,
  },
  {
    mode = "n",
    key = "<leader>q",
    action = ":quit<CR>",
    desc = "Quit window",
    opts = opts,
  },
  {
    mode = "n",
    key = "<leader>x",
    action = ":qa<CR>",
    desc = "Quit all",
    opts = opts,
  },

  -- Move to start/end of line
  {
    mode = "n",
    key = "H",
    action = "^",
    desc = "Move to start of line",
    opts = opts,
  },
  {
    mode = "n",
    key = "L",
    action = "$",
    desc = "Move to end of line",
    opts = opts,
  },

  -- Copy to clipboard in visual mode
  {
    mode = "v",
    key = "<leader>y",
    action = '"+y',
    desc = "Copy to clipboard",
    opts = opts,
  },

  -- Make delete not copy to default register
  {
    mode = "n",
    key = "d",
    action = '"_d',
    desc = "Delete without copying",
    opts = opts,
  },
  {
    mode = "n",
    key = "D",
    action = '"_D',
    desc = "Delete line without copying",
    opts = opts,
  },
  {
    mode = "v",
    key = "d",
    action = '"_d',
    desc = "Delete without copying",
    opts = opts,
  },
  {
    mode = "v",
    key = "D",
    action = '"_D',
    desc = "Delete line without copying",
    opts = opts,
  },
  {
    mode = "n",
    key = "x",
    action = '"_x',
    desc = "Delete character without copying",
    opts = opts,
  },
  {
    mode = "v",
    key = "x",
    action = '"_x',
    desc = "Delete character without copying",
    opts = opts,
  },
  {
    mode = "n",
    key = "c",
    action = '"_c',
    desc = "Change without copying",
    opts = opts,
  },
  {
    mode = "v",
    key = "c",
    action = '"_c',
    desc = "Change without copying",
    opts = opts,
  },

  -- Insert mode navigation
  {
    mode = "i",
    key = "<C-h>",
    action = "<Left>",
    desc = "Move cursor left",
    opts = opts,
  },
  {
    mode = "i",
    key = "<C-l>",
    action = "<Right>",
    desc = "Move cursor right",
    opts = opts,
  },
  {
    mode = "i",
    key = "<C-j>",
    action = "<Down>",
    desc = "Move cursor down",
    opts = opts,
  },
  {
    mode = "i",
    key = "<C-k>",
    action = "<Up>",
    desc = "Move cursor up",
    opts = opts,
  },

  -- Word navigation in insert mode
  {
    mode = "i",
    key = "<C-b>",
    action = "<S-Left>",
    desc = "Move to previous word",
    opts = opts,
  },
  {
    mode = "i",
    key = "<C-w>",
    action = "<S-Right>",
    desc = "Move to next word",
    opts = opts,
  },

  -- Start/end of line in insert mode
  {
    mode = "i",
    key = "<C-a>",
    action = "<Home>",
    desc = "Move to start of line",
    opts = opts,
  },
  {
    mode = "i",
    key = "<C-e>",
    action = "<End>",
    desc = "Move to end of line",
    opts = opts,
  },

  -- Delete word/line in insert mode
  {
    mode = "i",
    key = "<C-Backspace>",
    action = "<C-w>",
    desc = "Delete previous word",
    opts = opts,
  },
  {
    mode = "i",
    key = "<C-d>",
    action = "<Del>",
    desc = "Delete character under cursor",
    opts = opts,
  },
  {
    mode = "i",
    key = "<C-u>",
    action = "<C-o>d0",
    desc = "Delete to start of line",
    opts = opts,
  },

  -- Faster exit from insert mode
  {
    mode = "i",
    key = "<C-c>",
    action = "<Esc>",
    desc = "Exit insert mode",
    opts = opts,
  },
}

-- Function to set keybindings
function M.set_keymaps()
  for _, keymap in ipairs(keymaps) do
    vim.keymap.set(keymap.mode, keymap.key, keymap.action, keymap.opts)
  end
end

return M
