return {
  "whleucka/mantis.nvim",
  cmd = { "MantisIssues", "MantisSelectHost" },
  keys = {
    { "<leader>m", ":MantisIssues<cr>", desc = "Mantis Issues" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "grapp-dev/nui-components.nvim",
    "MunifTanjim/nui.nvim"
  },
  opts = require("config.mantis")
}
