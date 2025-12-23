return {
  "MeanderingProgrammer/treesitter-modules.nvim",
  opts = require("config.treesitter-modules"),
  priority = 200,
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    version = "main",
  }
}
