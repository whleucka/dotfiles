return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local with = require("core.utils").with
    with("which-key", function(m)
      local keymap = require("core.keymap")
      m.add(keymap)
    end)
  end
}
