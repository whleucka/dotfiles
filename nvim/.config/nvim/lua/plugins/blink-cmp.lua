vim.pack.add({
  "https://github.com/onsails/lspkind.nvim",
  {
    src = "https://github.com/Saghen/blink.cmp",
  }
})

local config = require("config.blink")
require("blink.cmp").setup(config)
