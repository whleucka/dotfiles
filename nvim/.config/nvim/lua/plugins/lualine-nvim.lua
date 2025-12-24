return {
  "nvim-lualine/lualine.nvim",
  event = "BufRead",
  opts = require("config.lualine"),
  dependencies = {
    { "https://github.com/arkav/lualine-lsp-progress" },
  }
}
