local with = require("core.utils").with

vim.pack.add {
  "https://github.com/nvim-lualine/lualine.nvim"
}

with("lualine", function(m)
  local config = require("config.lualine")
  m.setup(config)
end)

