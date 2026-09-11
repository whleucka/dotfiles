return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  cmd = { "ConformInfo" },
  -- Not `opts = require("config.conform")`: spec files are evaluated at
  -- startup, and config.conform pulls in conform.util, which is not on
  -- 'runtimepath' until the plugin itself has loaded.
  config = function()
    require("conform").setup(require("config.conform"))
  end,
}
