vim.pack.add {
  "https://github.com/tpope/vim-fugitive"
}

local wk = require("which-key")
wk.add({
  {
    "<leader>g",
    group = "Git (fugitive)",
    { "<leader>gs",  ":Git<CR>",             desc = "Status" },
    { "<leader>gB",  ":Git blame<CR>",       desc = "Blame" },
    { "<leader>gl",  ":0Gclog<CR>",          desc = "Log" },
    { "<leader>gc",  ":Git commit -v<CR>",   desc = "Commit" },
    { "<leader>go",  ":Git checkout ",       desc = "Checkout" },
    { "<leader>gb",  ":Git branch ",         desc = "Branch" },
    { "<leader>gm",  ":Git merge ",          desc = "Merge" },
    { "<leader>gM",  ":Git mergetool ",      desc = "Merge tool" },
    { "<leader>gP",  ":Git push<CR>",        desc = "Push" },
    { "<leader>gp",  ":Git pull<CR>",        desc = "Pull" },
    { "<leader>gf",  ":Git fetch<CR>",       desc = "Fetch" },
    { "<leader>ga",  ":Git add %<CR>",       desc = "Add current file" },

    { "<leader>gds", ":Gdiffsplit!<CR>",     desc = "Diff" },
    { "<leader>gdh", ":Ghdiffsplit!<CR>",    desc = "Diff (h-split)" },
    { "<leader>gdv", ":Gvdiffsplit!<CR>",    desc = "Diff (v-split)" },
    { "<leader>gdt", ":Git difftool -y<CR>", desc = "Diff tool" },
    { "<leader>gdg", ":diffget ",            desc = "Diff get" },
    { "<leader>gdq", ":diffoff!<CR>",        desc = "Quit diff mode" },
  },
})
