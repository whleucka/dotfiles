vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master"
  },
})

local config = require("config.treesitter")
require("nvim-treesitter").setup(config)
