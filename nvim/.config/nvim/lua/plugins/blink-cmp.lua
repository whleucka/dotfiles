return {
  "saghen/blink.cmp",
  dependencies = {
    'saghen/blink.lib',
    -- optional: provides snippets for the snippet source
    'rafamadriz/friendly-snippets',
  },
  event = "InsertEnter",
  opts = require("config.blink"),
  build = function()
    require('blink.cmp').build():wait(60000)
  end
}
