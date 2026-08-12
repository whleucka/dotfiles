return {
  "mrjones2014/smart-splits.nvim",
  event = "VeryLazy",
  opts = require("config.smart-splits"),
  keys = function()
    -- Inside herdr, herdr-splits.nvim owns nav (<C-M-hjkl>) and resize
    -- (<A-hjkl>) because it can cross into herdr panes; smart-splits has no
    -- herdr backend. Outside herdr these stay here, with the tmux integration
    -- and at_edge handoff in config/smart-splits.lua. Everything below the
    -- nav/resize block is smart-splits-only and loads either way.
    local nav_and_resize = vim.env.HERDR_ENV == "1" and {} or {
      { "<A-h>", require('smart-splits').resize_left,          desc = "Resize left" },
      { "<A-j>", require('smart-splits').resize_down,          desc = "Resize down" },
      { "<A-k>", require('smart-splits').resize_up,            desc = "Resize up" },
      { "<A-l>", require('smart-splits').resize_right,         desc = "Resize right" },
      { "<C-M-h>", require('smart-splits').move_cursor_left,   desc = "Move cursor left" },
      { "<C-M-j>", require('smart-splits').move_cursor_down,   desc = "Move cursor down" },
      { "<C-M-k>", require('smart-splits').move_cursor_up,     desc = "Move cursor up" },
      { "<C-M-l>", require('smart-splits').move_cursor_right,  desc = "Move cursor right" },
    }
    return vim.list_extend(nav_and_resize, {
      { "<leader>;", require('smart-splits').move_cursor_previous, desc = "Move cursor previous" },
      { "<leader><leader>h", require('smart-splits').swap_buf_left, desc = "Swap buffer left" },
      { "<leader><leader>j", require('smart-splits').swap_buf_down, desc = "Swap buffer odwn" },
      { "<leader><leader>k", require('smart-splits').swap_buf_up, desc = "Swap buffer up" },
      { "<leader><leader>l", require('smart-splits').swap_buf_right, desc = "Swap buffer right" },
    })
  end
}
