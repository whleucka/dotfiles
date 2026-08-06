return {
  "nvim-mini/mini-git",
  name = "mini.git",
  event = "VeryLazy",
  opts = {
    command = {
      split = "auto",
    },
  },
  keys = {
    {
      "<leader>g",
      group = "Git (neogit)",
      {
        "<leader>gB",
        ":vertical Git blame -- %<CR>",
        desc = "Blame file",
      },
      {
        "<leader>gs",
        function()
          MiniGit.show_at_cursor()
        end,
        desc = "Show at cursor",
        mode = { "n", "x" },
      },
    },
  },
}
