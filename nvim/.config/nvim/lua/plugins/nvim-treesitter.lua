return {
    "nvim-treesitter/nvim-treesitter",
    version = "master",
    config = function()
      local config = require("config.treesitter")
      require("nvim-treesitter").setup(config)
    end
}
