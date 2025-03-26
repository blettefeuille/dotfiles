local M = {}

-- Options to pass to the Telescope plugin
M.opts = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "bottom",
        preview_width = 0.55,
        results_width = 0.8,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules", ".git" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    use_less = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
  },
  extensions = {
    -- You can add extension configurations here
    -- Example:
    -- fzf = {
    --   fuzzy = true,
    --   override_generic_sorter = true,
    --   override_file_sorter = true,
    --   case_mode = "smart_case",
    -- },
  },
}

-- Keybindings to pass to the Telescope plugin
M.keys = {
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
  { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<leader>fs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
  { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy Find in Buffer" },
}

return M
