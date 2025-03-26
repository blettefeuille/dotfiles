-- ~/.config/nvim/lua/options.lua

local M = {}

-- Define options in a table
local options = {
  -- Tabs & Indentation
  expandtab = true,
  tabstop = 4,
  softtabstop = 4,
  shiftwidth = 4,
  smartindent = true,
  autoindent = true,
  smarttab = true,
  breakindent = true,

  -- UI Enhancements
  number = true,
  relativenumber = true,
  cursorline = true,
  wrap = true,
  signcolumn = "yes", -- Keep space for signs

  -- Search Settings
  incsearch = true,
  ignorecase = true,
  smartcase = true,

  -- Scrolling & Display
  scrolloff = 10,
  sidescrolloff = 8,

  -- Clipboard & Encoding
  clipboard = "unnamedplus",
  encoding = "utf-8",
  fileencoding = "utf-8",

  -- Splitting Behavior
  splitright = true,
  splitbelow = true,

  -- Persistent Undo
  undofile = true,

  -- Colors
  termguicolors = true, -- Enable 24-bit color

  -- Command preview
  inccommand = "split",
}

-- Define global variables in a table
local globals = {
  mapleader = " ", -- Set space as the leader key
}

-- Function to set options
function M.set_options()
  -- Apply Neovim options
  for key, value in pairs(options) do
    vim.opt[key] = value
  end

  -- Apply global variables
  for key, value in pairs(globals) do
    vim.g[key] = value
  end
end

return M
