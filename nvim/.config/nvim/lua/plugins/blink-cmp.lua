return {
  "Saghen/blink.cmp",
  dependencies = {
    "onsails/lspkind.nvim"
  },
  config = function()
    local config = require("config.blink")
    require("blink.cmp").setup(config)
  end
}
