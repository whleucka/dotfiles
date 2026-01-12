return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = require("config.oil"),
  keys = {
    { "<leader>o", ":Oil<CR>", desc = "Oil" },
  }
}
