return {
  "3rd/image.nvim",
  lazy = false, -- load immediately (or set to true if you want it on demand)
  opts = {
    backend = "kitty", -- since you're using Kitty terminal
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "quarto" },
      },
    },
    max_width = nil,
    max_height = nil,
    max_height_window_percentage = 50,
    max_width_window_percentage = 50,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  },
  config = function(_, opts)
    require("image").setup(opts)

    -- Auto render images when opening markdown-like files
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*.md", "*.markdown", "*.quarto" },
      callback = function()
        require("image").render()
      end,
    })
  end,
}

