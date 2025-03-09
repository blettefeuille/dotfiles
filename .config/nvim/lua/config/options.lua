local function set_options()
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.g.mapleader = " "
end

return {
  set_options = set_options
}
