return {
  theme = "hyper",
  config = {
    project = {
      enable = true,
      action = function(path)
        MiniFiles.open(path)
      end,
    },
    week_header = {
      enable = true,
    },
    packages = { enable = false },
    shortcut = {
      {
        desc = "Mount",
        group = "Label",
        action = ":SSHConnect",
        key = "m",
      },
      {
        desc = "New",
        group = "Label",
        action = ":enew",
        key = "n",
      },
      {
        desc = "Git",
        group = "Label",
        action = ":Neogit",
        key = "g",
      },
      {
        desc = "Files",
        group = "Label",
        action = function()
            MiniPick.builtin.files({ tool = 'git' })
        end,
        key = "f",
      },
      {
        desc = "Sync",
        group = "Label",
        action = ":StimSync",
        key = "s",
      },
      {
        desc = "Profile",
        group = "Label",
        action = ":StimProfile",
        key = "p",
      },
      {
        desc = "Config",
        group = "Label",
        action = function()
          MiniFiles.open(vim.fn.stdpath("config"))
        end,
        key = "c",
      },
      {
        desc = "Quit",
        group = "Number",
        action = function()
          vim.cmd [[quit]]
        end,
        key = "q",
      },
    },
    footer = {
      "",
      "With great power comes great responsibility",
      "",
    },
  },
}
