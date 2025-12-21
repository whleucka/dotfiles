return function()
  local startup_ms = nil

  -- Compute startup time
  if vim.g.__nvim_start_time then
    startup_ms = (vim.loop.hrtime() - vim.g.__nvim_start_time) / 1e6
  else
    startup_ms = 0
  end

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
        string.format("⚡ Startup time: %.2f ms", startup_ms),
      },
    },
  }
end
