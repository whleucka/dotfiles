return {
  enabled = true,
  dir = "/home/whleucka/Projects/mantis.nvim",
  name = "mantis-nvim",
  event = "VimEnter",
  keys = {
    { "<C-i>", ":MantisIssues<cr>", desc = "Mantis Issues" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "grapp-dev/nui-components.nvim",
    "MunifTanjim/nui.nvim"
  },
  opts = require("config.mantis-nvim")
}
