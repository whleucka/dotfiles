return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local keymap = require("core.keymap")
    require("which-key").add(keymap)
  end
}
