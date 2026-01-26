return {
  "uhs-robert/sshfs.nvim",
  dependencies = {
    "stevearc/oil.nvim",
  },
  event = "VeryLazy",
  opts = require("config.sshfs"),
  keys = {
    {
      "<leader>m",
      group = "SSHFS",
      {
        { "<leader>mm", ":SSHConnect<cr>",    desc = "Mount" },
        { "<leader>mu", ":SSHDisconnect<cr>", desc = "Disconnect" },
        { "<leader>mr", ":SSHReload<cr>",     desc = "Reload" },
        { "<leader>mf", ":SSHFiles<cr>",      desc = "Browse Files" },
        { "<leader>mF", ":SSHLiveFind ",      desc = "Live Find" },
        { "<leader>mg", ":SSHGrep<cr>",       desc = "Grep" },
        { "<leader>mG", ":SSHLiveGrep ",      desc = "Live Grep" },
        { "<leader>md", ":SSHChangeDir<cr>",  desc = "Change Directory" },
        { "<leader>me", ":SSHEdit<cr>",       desc = "Edit Config" },
        { "<leader>mc", ":SSHCommand<cr>",    desc = "Command" },
        { "<leader>mt", ":SSHTerminal<cr>",   desc = "Terminal" },
      },
    },
  }
}
