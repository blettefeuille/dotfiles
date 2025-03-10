local function set_keymaps()
  local opts = { noremap = true, silent = true }
  local builtin = require('telescope.builtin')
  
  -- Telescope
  vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find files' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })

  -- Colorscheme
  vim.keymap.set("n", "<leader>ct", "<cmd>lua require('config.colorscheme').set_theme(vim.fn.input('Theme: '))<CR>",
    { desc = 'Change theme' })
  vim.keymap.set('n', '<leader>cd', function()
    local theme = vim.fn.input('New default theme: ')
    require('config.colorscheme').set_default_theme(theme)
  end, { desc = 'Change default theme' })

  -- Save and quit
  vim.keymap.set("n", "<leader>w", ":update<Return>", opts)
  vim.keymap.set("n", "<leader>q", ":quit<Return>", opts)
  vim.keymap.set("n", "<leader>w", ":qa<Return>", opts)
end

return {
  set_keymaps = set_keymaps
}
