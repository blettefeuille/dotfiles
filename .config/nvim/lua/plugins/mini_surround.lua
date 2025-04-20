return {
  "echasnovski/mini.surround",
  version = false, -- always use latest
  event = "VeryLazy",
  opts = {
    -- disable default mappings to stay minimal and clever
    mappings = {
      add = "gsa",            -- Add surrounding
      delete = "gsd",         -- Delete surrounding
      find = "gsf",           -- Find right surrounding
      find_left = "gsF",      -- Find left surrounding
      highlight = "gsh",      -- Highlight surrounding
      replace = "gsr",        -- Replace surrounding
      update_n_lines = "gsn", -- Update number of lines
    },
    n_lines = 20, -- how far to look for surroundings
    search_method = "cover_or_next", -- clever method
  },
}
