return {
  "nvimdev/dashboard-nvim",
  priority = 0, -- load this plugin last to get accurate startup time
  event = "VimEnter",
  config = function()
    local config = require("config.dashboard")
    require("dashboard").setup(config)
  end,
  keys = {
    { "<leader>D", ":Dashboard<cr>", desc = "Dashboard" }
  }
}
