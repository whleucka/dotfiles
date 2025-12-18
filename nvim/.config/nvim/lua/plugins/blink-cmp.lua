return {
  "Saghen/blink.cmp",
  dependencies = {
    "onsails/lspkind.nvim"
  },
  event = { "BufRead" },
  config = function()
    local config = require("config.blink")
    require("blink.cmp").setup(config)
  end
}
