return {
  "MeanderingProgrammer/treesitter-modules.nvim",
  opts = require("config.treesitter-modules"),
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}
