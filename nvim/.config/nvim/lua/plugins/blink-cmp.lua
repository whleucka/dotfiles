return {
  "saghen/blink.cmp",
  dependencies = {
    "saghen/blink.lib",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },
  event = "InsertEnter",
  opts = require("config.blink"),
  build = function()
    require("blink.cmp").build():wait(60000)
  end,
}
