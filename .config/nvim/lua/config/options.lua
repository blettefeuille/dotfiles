local function set_options()
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.g.mapleader = " "
  vim.opt.relativenumber = true
  vim.opt.number = true
  vim.opt.incsearch = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.wrap = true
  vim.opt.clipboard = "unnamedplus"
  vim.opt.cursorline = true
  vim.opt.smartindent = true
  vim.opt.autoindent = true
  vim.opt.encoding = "utf-8"
  vim.opt.fileencoding = "utf-8"
  vim.opt.title = true
  vim.opt.scrolloff = 10
  vim.opt.smarttab = true
  vim.opt.inccommand = "split"
  vim.opt.ignorecase = true
  vim.opt.breakindent = true
end

return {
  set_options = set_options
}
