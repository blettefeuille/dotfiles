return {
  {
    "rcarriga/nvim-notify",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      background_colour = "#1e1e2e", -- Replace with your actual catppuccin.base color
      fps = 120,
      icons = {
        DEBUG = "󰇚",
        ERROR = "󰅙",
        INFO = "󰋽",
        TRACE = "󰥔",
        WARN = "󰀪",
      },
      level = 2,
      minimum_width = 50,
      render = "wrapped-compact",
      stages = "slide",
      timeout = 3000,
      top_down = true,
      -- Enable TreeSitter highlighting in notifications
      on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        if pcall(require, "nvim-treesitter") then
          vim.treesitter.start(buf, "markdown") -- Use markdown parser for notifications
        end
      end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify

      -- Telescope keymap for notification history
      vim.keymap.set("n", "<leader>fn", function()
        require("telescope").extensions.notify.notify()
      end, { desc = "Find notifications" })
    end,
  },
  -- Optional: Ensure treesitter markdown parser is installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "markdown" },
    },
  },
}
