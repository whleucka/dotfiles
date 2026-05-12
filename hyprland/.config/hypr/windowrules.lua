-- Window Rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Floating windows
hl.window_rule({ match = { class = "pavucontrol" },                                       float = true })
hl.window_rule({ match = { class = "nm-connection-editor" },                              float = true })
hl.window_rule({ match = { class = "blueman-manager" },                                   float = true })
hl.window_rule({ match = { class = "thunar", title = "File Operation Progress" },         float = true })
hl.window_rule({ match = { class = "org.gnome.Calculator" },                              float = true })
hl.window_rule({ match = { class = "imv" },                                               float = true })
hl.window_rule({ match = { title = "Picture-in-Picture" },                                float = true })

-- File dialogs
hl.window_rule({ match = { title = "Open File" },    float = true })
hl.window_rule({ match = { title = "Save File" },    float = true })
hl.window_rule({ match = { title = "Save As" },      float = true })
hl.window_rule({ match = { title = "Open Folder" },  float = true })

-- Polkit
hl.window_rule({ match = { class = "polkit-gnome-authentication-agent-1" }, float = true })

-- Opacity
hl.window_rule({ match = { class = "kitty" }, opacity = "0.95 0.85" })

-- Size and position
hl.window_rule({ match = { class = "pavucontrol" }, size = { 800, 600 } })
hl.window_rule({ match = { class = "pavucontrol" }, center = true })

-- Idle inhibit (prevent screen lock)
hl.window_rule({ match = { class = "chromium" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "firefox" },  idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "mpv" },      idle_inhibit = "fullscreen" })

-- Single window — no gaps, border, or rounding
hl.workspace_rule({ workspace = "w[t1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { workspace = "w[t1]" }, border_size = 0 })
hl.window_rule({ match = { workspace = "w[t1]" }, rounding = 0 })

-- XWayland
hl.window_rule({ match = { xwayland = true }, no_anim = true })
