return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VimEnter",
  opts = require("config.oil"),
  keys = {
    { "<leader>o", ":Oil<CR>", desc = "Oil" },
  },
}
