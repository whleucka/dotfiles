vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/sindrets/diffview.nvim',
  'https://github.com/NeogitOrg/neogit',
})

local wk = require("which-key")
wk.add({
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
