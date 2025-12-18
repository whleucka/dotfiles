local with = require("core.utils").with

vim.pack.add {
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons"
}

with("oil", function(m)
  local config = require("config.oil")
  m.setup(config)
end)

with("which-key", function(m)
  m.add({
    { "<leader>o", ":Oil<CR>", desc = "Oil" },
  })
end)
