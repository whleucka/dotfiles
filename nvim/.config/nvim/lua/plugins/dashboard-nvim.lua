return {
  "nvimdev/dashboard-nvim",
  config = function()
    local config = require("config.dashboard")
    require("dashboard").setup(config)
  end,
  keys = {
    { "<leader>D", ":Dashboard<cr>", desc = "Dashboard" }
  }
}
