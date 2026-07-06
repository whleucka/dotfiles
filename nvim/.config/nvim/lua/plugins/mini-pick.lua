return {
  'nvim-mini/mini.pick',
  event = "VeryLazy",
  keys = {
    {
      "<leader>o",
      function()
        MiniPick.builtin.files({ tool = 'git' })
      end,
      desc = "Files (git)"
    },
    {
      "<leader>f",
      group = "Find",
      {
        {
          "<leader>fc",
          function()
            MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config")}})
          end,
          desc = "Config"
        },
      },
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
          "<leader>fg",
          function()
            MiniPick.builtin.grep_live()
          end,
          desc = "Grep live"
        },
      },
      {
        {
          "<leader>fG",
          ':Pick grep pattern="<cword>"<CR>',
          desc = "Grep word"
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
          "<leader>fh",
          function()
            MiniPick.builtin.help()
          end,
          desc = "Help"
        },
      },
    },
  }
}
