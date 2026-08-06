return {
  "NeogitOrg/neogit",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  opts = {
    integrations = {
      diffview = true,
      mini_pick = true,
    },
  },
  keys = {
    {
      "<leader>g",
      group = "Git (neogit)",
      {
        "<leader>gg",
        function()
          require("neogit").open({ kind = "auto" })
        end,
        desc = "Open Neogit",
      },
      {
        "<leader>gc",
        function()
          require("neogit").open({ "commit", kind = "auto" })
        end,
        desc = "Commit",
      },
      {
        "<leader>gp",
        function()
          require("neogit").open({ "push", kind = "auto" })
        end,
        desc = "Push",
      },
      {
        "<leader>gP",
        function()
          require("neogit").open({ "pull", kind = "auto" })
        end,
        desc = "Pull",
      },
      {
        "<leader>gb",
        function()
          require("neogit").open({ "branch", kind = "auto" })
        end,
        desc = "Branch",
      },
      {
        "<leader>gl",
        function()
          require("neogit").open({ "log", kind = "auto" })
        end,
        desc = "Log",
      },
      { "<leader>gf", ":DiffviewFileHistory %<CR>", desc = "File history",      mode = "n" },
      { "<leader>gf", ":DiffviewFileHistory<CR>",   desc = "Line history",      mode = "x" },
      { "<leader>gd", ":DiffviewOpen<CR>",          desc = "Diff working tree", mode = "n" },
    },
  },
}
