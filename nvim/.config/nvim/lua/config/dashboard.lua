-- Banner is 67 cols wide; hyper's generate_header() centers it for us.
local banner = {
  "",
  "██╗    ██╗██╗  ██╗██╗     ███████╗██╗   ██╗ ██████╗██╗  ██╗ █████╗ ",
  "██║    ██║██║  ██║██║     ██╔════╝██║   ██║██╔════╝██║ ██╔╝██╔══██╗",
  "██║ █╗ ██║███████║██║     █████╗  ██║   ██║██║     █████╔╝ ███████║",
  "██║███╗██║██╔══██║██║     ██╔══╝  ██║   ██║██║     ██╔═██╗ ██╔══██║",
  "╚███╔███╔╝██║  ██║███████╗███████╗╚██████╔╝╚██████╗██║  ██╗██║  ██║",
  " ╚══╝╚══╝ ╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝",
  "",
  "──────────────────  n  e  o  v  i  m  ──────────────────",
  "",
}

-- Startup stats.
--
-- Two constraints force this shape. (1) dashboard-nvim caches its opts to disk
-- and serialises function options with string.dump() (init.lua:165), which
-- discards upvalues -- :Dashboard rebuilds this via loadstring() (hyper.lua:501),
-- so it may close over nothing and must read globals only. (2) It must never
-- yield to the event loop. gen_footer() calls it at hyper.lua:504 but only
-- computes its insert position at hyper.lua:509, after it returns; a yield in
-- between lets a competing render finish, so the stale position appends a
-- second footer (and, on a buffer that render left locked, throws).
--
-- So the plugin count is precomputed (it needs vim.pack.get(), which yields),
-- while the elapsed time is measured here on the first draw -- reltime() does
-- not yield, and this is the only point that knows when the UI was actually
-- ready. Both are then frozen: they describe startup, so :Dashboard an hour
-- later must not re-measure.
local function footer()
  -- A local literal, not an upvalue -- constants survive string.dump().
  local quote = "With great power comes great responsibility"

  local count = vim.g.dashboard_plugin_count
  if type(count) ~= "number" then
    return { "", quote, "" }
  end

  local ready = vim.g.dashboard_ready_ms
  if type(ready) ~= "number" then
    ready = 0
    if vim.g.start_time then
      ready = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time)) * 1000
    end
    vim.g.dashboard_ready_ms = ready
  end

  local v = vim.version()
  return {
    "",
    quote,
    "",
    ("⚡ %d plugins  •  ready in %.0fms  •  nvim %d.%d.%d"):format(
      count,
      ready,
      v.major,
      v.minor,
      v.patch
    ),
    "",
  }
end

return {
  theme = "hyper",
  config = {
    header = banner,
    project = {
      enable = true,
      action = function(path)
        MiniFiles.open(path)
      end,
    },
    -- week_header generates its own day-of-the-week art and takes precedence
    -- over config.header, so it has to be off for the banner to show at all.
    week_header = {
      enable = false,
    },
    packages = { enable = false },
    shortcut = {
      {
        desc = "Explore",
        group = "Label",
        action = function()
          MiniFiles.open()
        end,
        key = "e",
      },
      {
        desc = "Mantis Issues",
        group = "Label",
        action = ":MantisIssues",
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
        desc = "Find Files",
        group = "Label",
        action = function()
          MiniPick.builtin.files()
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
          MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
        end,
        key = "c",
      },
      {
        desc = "Quit",
        group = "Number",
        action = function()
          vim.cmd([[quit]])
        end,
        key = "q",
      },
    },
    footer = footer,
  },
}
