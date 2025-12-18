local with = require("core.utils").with

vim.pack.add {
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/whleucka/bodybuilder.nvim"
}

with("bodybuilder", function(m)
  local config = require("config.bodybuilder")
  -- See https://github.com/ollama/ollama
  m.setup(config)
end)
