local with = require("core.utils").with

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
}

with("which-key", function(m)
  m.add({
    {
      "<leader>g",
      group = "Git (neogit)",
      {
        "<leader>gg",
        function()
          require('neogit').open({ kind = "auto" })
        end,
      },
    },
  })
end)
