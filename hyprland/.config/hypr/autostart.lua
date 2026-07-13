-- Autostart Applications

hl.on("hyprland.start", function()
    -- Core services
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Polkit agent (for GUI sudo prompts)
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Wallpaper (time-of-day Tahoe Beach cycler)
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("sleep 1 && ~/.config/hypr/scripts/tahoe-wallpaper.sh daemon")

    -- Status bar (workspace state listener feeds the ws buttons; start it first)
    hl.exec_cmd("~/.config/waybar/scripts/ws-listener.sh")
    hl.exec_cmd("waybar")

    -- Notifications
    hl.exec_cmd("mako")

    -- Idle and lock
    hl.exec_cmd("~/.config/hypr/scripts/hypridle-battery.sh")

    -- Clipboard manager
    -- wl-clip-persist takes ownership of selection so cliphist's watchers
    -- don't race kitty's clipboard write (broken-pipe -> empty primary).
    hl.exec_cmd("wl-clip-persist --clipboard both")
    hl.exec_cmd("wl-paste --type text --watch cliphist store -max-items 750")
    hl.exec_cmd("wl-paste --type image --watch cliphist store -max-items 100")
    hl.exec_cmd("wl-paste --primary --type text --watch cliphist store -max-items 500")

    -- OSD
    hl.exec_cmd("swayosd-server")

    -- Network applet
    hl.exec_cmd("nm-applet --indicator")

    -- Bluetooth applet
    hl.exec_cmd("blueman-applet")
end)
