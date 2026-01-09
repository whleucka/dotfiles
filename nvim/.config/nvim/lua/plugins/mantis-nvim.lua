return {
  enabled = true,
  dir = "/home/whleucka/Projects/mantis-nvim",
  name = "mantis-nvim",
  event = "VimEnter",
  keys = {
    { "<leader>M", ":Mantis<cr>", desc = "Mantis Issues" },
  },
  dependencies = {
    "grapp-dev/nui-components.nvim",
    "MunifTanjim/nui.nvim"
  },
  opts = require("config.mantis-nvim")
}
