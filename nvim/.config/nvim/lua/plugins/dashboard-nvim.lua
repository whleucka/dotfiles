vim.pack.add {
  "https://github.com/nvimdev/dashboard-nvim",
}

local config = require("config.dashboard")
require('dashboard').setup(config)

local wk = require("which-key")
wk.add({
  { "<leader>D", ":Dashboard<cr>", desc = "Dashboard" },
})
