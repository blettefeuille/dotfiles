local function set_options()
  local opt = vim.opt
  local g = vim.g

  -- Tabs & Indentation
  opt.expandtab = true
  opt.tabstop = 2
  opt.softtabstop = 2
  opt.shiftwidth = 2
  opt.smartindent = true
  opt.autoindent = true
  opt.smarttab = true
  opt.breakindent = true

  -- UI Enhancements
  opt.number = true
  opt.relativenumber = true
  opt.cursorline = true
  opt.wrap = true
  opt.signcolumn = "yes" -- Keep space for signs

  -- Search Settings
  opt.incsearch = true
  opt.ignorecase = true
  opt.smartcase = true

  -- Scrolling & Display
  opt.scrolloff = 10
  opt.sidescrolloff = 8
  opt.updatetime = 250 -- Faster UI responsiveness
  opt.timeoutlen = 500 -- Faster key sequence recognition

  -- Clipboard & Encoding
  opt.clipboard = "unnamedplus"
  opt.encoding = "utf-8"
  opt.fileencoding = "utf-8"

  -- Splitting Behavior
  opt.splitright = true
  opt.splitbelow = true

  -- Persistent Undo
  opt.undofile = true

  -- Colors
  opt.termguicolors = true -- Enable 24-bit color

  -- Command preview
  opt.inccommand = "split"

  -- Leader key
  g.mapleader = " "
end

return {
  set_options = set_options
}

