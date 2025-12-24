return {
  "ibhagwan/fzf-lua",
  opts = { 'fzf-native' },
  event = "VeryLazy",
  keys = {
    {
      "<leader>s",
      group = "Search",
      { "<leader>sg", ":FzfLua grep<cr>",      desc = "Grep" },
      { "<leader>s/", ":FzfLua live_grep<cr>", desc = "Live grep" },
    },
    {
      "<leader>f",
      group = "Find",
      { "<leader>ff", ":FzfLua files<cr>",    desc = "Files" },
      { "<leader>fh", ":FzfLua helptags<cr>", desc = "Help" },
      {
        "<leader>fc",
        function()
          require('fzf-lua').files({
            cwd = vim.fn.stdpath('config')
          })
        end,
        desc = "Config"
      },
      { "<leader>fm", ":FzfLua manpages<cr>",  desc = "Manpages" },
      { "<leader>fk", ":FzfLua keymaps<cr>",   desc = "Keymap" },
      { "<leader>fg", ":FzfLua git_files<cr>", desc = "Git files" },
      { "<leader>fo", ":FzfLua oldfiles<cr>",  desc = "Opened files" },
      { "<leader>fb", ":FzfLua buffers<cr>",   desc = "Buffers" },
      { "<leader>ft", ":FzfLua tabs<cr>",      desc = "Tabs" },
      { "<leader>fq", ":FzfLua quickfix<cr>",  desc = "Quickfix" },
      { "<leader>fl", ":FzfLua loclist<cr>",   desc = "Location list" },
      { "<leader>/",  ":FzfLua blines<cr>",    desc = "Lines" },
    },

  }
}
