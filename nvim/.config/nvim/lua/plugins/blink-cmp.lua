return {
  "Saghen/blink.cmp",
  dependencies = {
    "onsails/lspkind.nvim"
  },
  event = "InsertEnter",
  opts = require("config.blink"),
}
