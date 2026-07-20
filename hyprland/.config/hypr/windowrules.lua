-- Window Rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Floating windows
hl.window_rule({ match = { class = "pavucontrol" }, float = true })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "thunar", title = "File Operation Progress" }, float = true })
hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true })
hl.window_rule({ match = { class = "imv" }, float = true })
--hl.window_rule({ match = { title = "Picture-in-Picture" }, float = true })

-- Apps with shared dialog/main class — float all, tile manually if needed
hl.window_rule({ match = { class = "^[Gg]imp.*" }, float = true })
--hl.window_rule({ match = { class = "xournalpp" }, float = true })

-- Small popups / utilities
hl.window_rule({ match = { class = "satty" }, float = true })
hl.window_rule({ match = { class = "org.gnome.DiskUtility" }, float = true })
--hl.window_rule({ match = { class = "Bitwarden" }, float = true })
--hl.window_rule({ match = { class = "nwg-look" }, float = true })
hl.window_rule({ match = { class = "tlpui" }, float = true })
--hl.window_rule({ match = { class = "cmake-gui" }, float = true })

-- Auth & confirmation dialogs
--hl.window_rule({ match = { title = "^Authentication Required$" }, float = true })
--hl.window_rule({ match = { title = "^(Confirm|Quit).*" }, float = true })
--hl.window_rule({ match = { class = "pinentry-qt" }, float = true })
--hl.window_rule({ match = { class = "pinentry-qt5" }, float = true })
--hl.window_rule({ match = { class = "gcr-prompter" }, float = true })

-- File dialogs (matches Open/Save/Export across GTK apps, GIMP, Inkscape, browsers)
hl.window_rule({ match = { title = "^(Open|Save|Export|Import)( As)?( File| Image| Folder| Document)?\\.?\\.?\\.?$" }, float = true })
hl.window_rule({ match = { title = "^(Select|Choose) (File|Folder|Image|Directory).*" }, float = true })

-- Polkit
hl.window_rule({ match = { class = "polkit-gnome-authentication-agent-1" }, float = true })

-- Opacity
--hl.window_rule({ match = { class = "kitty" }, opacity = "0.95 0.85" })

-- Size and position
hl.window_rule({ match = { class = "pavucontrol" }, size = { 800, 600 } })
hl.window_rule({ match = { class = "pavucontrol" }, center = true })

-- Idle inhibit (prevent screen lock)
hl.window_rule({ match = { class = "chromium" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^[Gg]oogle-chrome.*" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "mpv" }, idle_inhibit = "fullscreen" })

-- NOTE: no "smart gaps" rule. A w[t1]/w[tv1] single-window-no-gaps rule counts
-- a whole group as one tile, so a lone group goes edge-to-edge and its groupbar
-- jams against the waybar. It also makes mod+M maximize look like a no-op and
-- makes float/unfloat snap the remaining window. Consistent gaps everywhere
-- avoids all three. There is no selector/match that excludes groups from it.

-- XWayland
hl.window_rule({ match = { xwayland = true }, no_anim = true })
