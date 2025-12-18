local with = require("core.utils").with

vim.pack.add {
  "https://github.com/folke/which-key.nvim"
}

with("which-key", function(m)
  m.add({
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Help",
    }
  })
end)
