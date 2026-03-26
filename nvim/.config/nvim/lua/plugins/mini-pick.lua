return {
  'nvim-mini/mini.pick',
  event = "VeryLazy",
  keys = {
    {
      "<leader>f",
      group = "Find",
      {
        {
          "<leader>ff",
          function()
            MiniPick.builtin.files()
          end,
          desc = "Files"
        },
      },
      {
        {
          "<leader>fr",
          function()
            MiniPick.builtin.resume()
          end,
          desc = "Resume"
        },
      },
      {
        {
          "<leader>fb",
          function()
            MiniPick.builtin.buffers()
          end,
          desc = "Buffers"
        },
      },
      {
        {
          "<leader>fg",
          function()
            MiniPick.builtin.grep_live()
          end,
          desc = "Grep (live)"
        },
      },
      {
        {
          "<leader>fh",
          function()
            MiniPick.builtin.help()
          end,
          desc = "Help"
        },
      },
      {
        {
          "<leader>fG",
          function()
            MiniPick.builtin.files({ tool = 'git' })
          end,
          desc = "Files (git)"
        },
      },
    },
  }
}
