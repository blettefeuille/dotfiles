return {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*" },  -- Apply to all filetypes
      user_default_options = {
      rgb_fn = true,  -- Enable parsing of rgb() and rgba() functions
      mode = "background",  -- Set highlight mode to background
    },
  }
}
