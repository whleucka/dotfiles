return function()
  local stats = require("stimpack").get_stats()
  local stimpack_startup_ms = stats.startup_time_ms
  local plugins = stats.loaded_plugins

  local end_time = vim.fn.reltime()
  local total_startup_ms = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time, end_time)) * 1000

  return {
    theme = "hyper",
    config = {
      project = {
        enable = true,
        action = function(path)
          -- use fzf-lua instead of telescope
          require("fzf-lua").files({ cwd = path })
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
          desc = "Oil",
          group = "Label",
          action = ":Oil",
          key = "o",
        },
        {
          desc = "Files",
          group = "Label",
          action = "FzfLua files",
          key = "f",
        },
        {
          desc = "Sync",
          group = "Label",
          action = ":StimSync",
          key = "s",
        },
        {
          desc = "Config",
          group = "Label",
          action = function()
            require("fzf-lua").files({
              cwd = vim.fn.stdpath("config"),
            })
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
        string.format("💉 Stimpack configured (%d plugins) in %.2fms", plugins, stimpack_startup_ms),
        string.format("⚡ Dashboard loaded in %.2fms", total_startup_ms),
      },
    },
  }
end
