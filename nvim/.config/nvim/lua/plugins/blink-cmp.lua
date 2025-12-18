local with = require("core.utils").with

vim.pack.add {
  "https://github.com/onsails/lspkind.nvim",
  "https://github.com/Saghen/blink.cmp",
}

with("blink.cmp", function(m)
  local config = require("config.blink")
  m.setup(config)
end)
