return {
  "mrjones2014/smart-splits.nvim",
  opts = require("config.smart-splits"),
  keys = function()
    return {
      { "<A-h>", require('smart-splits').resize_left,          desc = "Resize left" },
      { "<A-j>", require('smart-splits').resize_down,          desc = "Resize down" },
      { "<A-k>", require('smart-splits').resize_up,            desc = "Resize up" },
      { "<A-l>", require('smart-splits').resize_right,         desc = "Resize right" },
      { "<C-h>", require('smart-splits').move_cursor_left,     desc = "Move cursor left" },
      { "<C-j>", require('smart-splits').move_cursor_down,     desc = "Move cursor down" },
      { "<C-k>", require('smart-splits').move_cursor_up,       desc = "Move cursor up" },
      { "<C-l>", require('smart-splits').move_cursor_right,    desc = "Move cursor right" },
      { "<C-;>", require('smart-splits').move_cursor_previous, desc = "Move cursor previous" },
      { "<leader><leader>h", require('smart-splits').swap_buf_left, desc = "Swap buffer left" },
      { "<leader><leader>j", require('smart-splits').swap_buf_down, desc = "Swap buffer odwn" },
      { "<leader><leader>k", require('smart-splits').swap_buf_up, desc = "Swap buffer up" },
      { "<leader><leader>l", require('smart-splits').swap_buf_right, desc = "Swap buffer right" },
    }
  end
}
