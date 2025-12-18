local with = require("core.utils").with

vim.pack.add {
  "https://github.com/nvimdev/dashboard-nvim",
}

with("dashboard", function(m)
  local config = require("config.dashboard")
  m.setup(config)
end)

with("which-key", function(m)
  m.add({
    { "<leader>D", ":Dashboard<cr>", desc = "Dashboard" },
  })
end)
