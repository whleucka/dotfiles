return {
  "Saghen/blink.cmp",
  dependencies = {
    "onsails/lspkind.nvim"
  },
  event = "InsertEnter",
  config = function()
    local config = require("config.blink")
    require("blink.cmp").setup(config)
  end
}
