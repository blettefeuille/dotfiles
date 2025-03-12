return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    -- Require the neotree plugin
    local neotree = require("neo-tree")

    -- Configure NeoTree
    neotree.setup({
      -- General options for NeoTree
      filesystem = {
        filtered_items = {
          visible = true,  -- Ensure all files are visible by default
          hide_dotfiles = false,  -- Don't hide dotfiles
          hide_gitignored = false,  -- Don't hide files listed in .gitignore
        },
        follow_current_file = true,  -- Follow the cursor in the file tree
      },

      -- Git status integration
      git_status = {
        enabled = true,  -- Enable Git integration
        show_modified = true,  -- Show modified files
        show_staged = true,  -- Show staged files
        show_untracked = true,  -- Show untracked files
      },

      -- Problems integration (showing warnings, errors, and info)
      diagnostics = {
        enabled = true,
        show_errors = true,
        show_warnings = true,
        show_info = true,
        -- You can configure the icons for different problem types here
        icons = {
          error = "",
          warning = "",
          info = "",
        },
      },

      -- Add other sections like buffers, tags, etc., if necessary
      buffers = {
        visible = false,  -- Hide buffer section by default
      },

      -- Auto close the tree when opening a file
      window = {
        width = 40,  -- Set the width of the file tree
        position = "left",  -- Position it to the left side
        auto_resize = true,  -- Auto resize when possible
      },
    })
  end
}

