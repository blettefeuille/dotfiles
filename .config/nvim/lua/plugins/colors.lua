return {
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = true,
          RRGGBBAA = true,
          mode = "background",
        }
      })
    end
  },
  {
    "nvzone/volt",
    lazy = true, -- Load volt lazily
  },
  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
    dependencies = { "nvzone/volt" }, -- Explicitly declare volt as a dependency
  },
}
