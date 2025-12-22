return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "MeanderingProgrammer/treesitter-modules.nvim"
    },
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      local config = require("config.treesitter")
      require("treesitter-modules").setup(config)
    end
}
