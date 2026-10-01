-- herdr-splits.nvim — nvim <-> herdr pane navigation and resize.
--
-- Loaded everywhere, herdr or not. Every herdr call is gated on
-- HERDR_ENV/HERDR_PANE_ID, so outside herdr it degrades to plain neovim split
-- nav/resize and at_edge still hands off to Hyprland — what smart-splits.nvim
-- used to cover there.
--
-- Keys arrive here from herdr: Hyprland's super+hjkl injects ctrl+alt+hjkl into
-- the pty, and ~/.config/hypr/scripts/herdr-route forwards it to this pane when
-- it sees (n)vim running. alt+hjkl arrives the same way for resize — needed
-- because herdr's direct chords otherwise win over the pane's program.
--
-- Only the neovim half of the upstream project is used: herdr-splits.nvim talks
-- to herdr over the plain `herdr pane ...` CLI, so `herdr plugin install` is NOT
-- required. Its shipped herdr-side scripts are deliberately not installed —
-- they can only wrap or stop at herdr's outer edge, and we need the Hyprland
-- hop. herdr-route covers plain panes instead.
return {
  "lmilojevicc/herdr-splits.nvim",
  event = "VeryLazy",
  opts = {
    -- Match the chords herdr-route forwards, in neovim notation. setup()
    -- translates these into herdr notation and publishes them to
    -- ~/.config/herdr/plugins/config/herdr-splits/herdr-splits.conf. That file
    -- is only read by the plugin's own herdr-side scripts, which we don't use,
    -- so it is inert here — but keeping it accurate avoids confusion later.
    nav_keys = { left = "<C-M-h>", down = "<C-M-j>", up = "<C-M-k>", right = "<C-M-l>" },
    resize_keys = { left = "<A-h>", down = "<A-j>", up = "<A-k>", right = "<A-l>" },

    -- The outer edge of the unified keychain. This fires only once we're at
    -- BOTH the neovim window edge and herdr's pane edge (nav.lua checks
    -- `pane edges` before calling us), so there is no layer left below —
    -- go straight to the Hyprland window. This callback is the reason the
    -- plugin is usable here at all; its plain-pane equivalent has no such hook.
    at_edge = function(ctx)
      local dir = ({ left = "l", right = "r", up = "u", down = "d" })[ctx.direction]
      vim.fn.system({ os.getenv("HOME") .. "/.config/hypr/scripts/focus", dir })
    end,

    -- Resize steps: 0.05 of the terminal for a herdr divider (matches
    -- herdr-route's resize_amount), 3 cells for a native neovim split
    -- (also what you get outside herdr).
    default_amount = 0.05,
    neovim_amount = 3,

    -- HERDR_BIN_PATH is documented as injected into every pane but is unset
    -- here on herdr 0.8.0, which would leave the plugin calling a bare `herdr`.
    -- Pin it, same reasoning as the PATH export in herdr-route.
    herdr_bin = os.getenv("HOME") .. "/.local/bin/herdr",

    -- Never let the plugin re-checkout itself behind lazy.nvim's back.
    auto_sync_herdr = false,

    ignored_buftypes = { "nofile", "quickfix", "prompt" },
    ignored_filetypes = { "NvimTree" },
    move_cursor_same_row = false,
    ignored_events = { "BufEnter", "WinEnter" },
  },
  keys = {
    { "<C-M-h>", function() require("herdr-splits").move_cursor_left() end,  desc = "Move cursor left (herdr)" },
    { "<C-M-j>", function() require("herdr-splits").move_cursor_down() end,  desc = "Move cursor down (herdr)" },
    { "<C-M-k>", function() require("herdr-splits").move_cursor_up() end,    desc = "Move cursor up (herdr)" },
    { "<C-M-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Move cursor right (herdr)" },
    { "<A-h>",   function() require("herdr-splits").resize_left() end,       desc = "Resize left (herdr)" },
    { "<A-j>",   function() require("herdr-splits").resize_down() end,       desc = "Resize down (herdr)" },
    { "<A-k>",   function() require("herdr-splits").resize_up() end,         desc = "Resize up (herdr)" },
    { "<A-l>",   function() require("herdr-splits").resize_right() end,      desc = "Resize right (herdr)" },
  },
}
