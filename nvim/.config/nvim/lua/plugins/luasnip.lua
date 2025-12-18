local with = require("core.utils").with

vim.pack.add {
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets"
}

with("luasnip", function()
  require("luasnip.loaders.from_vscode").lazy_load()
end)
