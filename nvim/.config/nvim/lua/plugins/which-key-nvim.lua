return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  main = "which-key",
  config = function()
    local keymap = require("core.keymap")
    require("which-key").add(keymap)
  end
}
