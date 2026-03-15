return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    -- Only save sessions when explicitly in a kitty session (or always, if you prefer)
    auto_save = true,
    auto_restore = true,
    -- Suppress session restore messages
    suppress_dirs = { "~/", "~/Downloads", "/tmp" },
  },
}
