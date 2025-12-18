local with = require("core.utils").with

vim.pack.add {
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "master"
  },
}

with("nvim-treesitter", function(m)
  local config = require("config.treesitter")
  m.setup(config)
end)
