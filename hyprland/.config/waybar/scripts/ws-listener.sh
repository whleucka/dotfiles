#!/bin/bash
# Event-driven workspace state cache for Waybar.
#
# Subscribes to Hyprland's event socket (socket2) and, on any workspace/window
# change, writes a tiny state file that ws-button.sh reads. This replaces the
# old per-second polling where all 10 buttons each forked hyprctl+jq (~40
# processes/sec). Now hyprctl is queried once per actual change, and buttons
# just read the cache with shell builtins.
#
# Cache format (two lines):
#   active <id>
#   occupied <id> <id> ...

CACHE="${XDG_RUNTIME_DIR:-/tmp}/waybar-ws.state"
SOCK="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Single instance: if a listener already holds the lock, exit quietly.
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/waybar-ws-listener.lock"
flock -n 9 || exit 0

write_state() {
    local active occupied
    active=$(hyprctl activeworkspace -j | jq -r '.id')
    occupied=$(hyprctl workspaces -j | jq -r '.[] | select(.windows > 0 and .id > 0) | .id' | tr '\n' ' ')
    # Atomic write so ws-button.sh never reads a half-written file.
    printf 'active %s\noccupied %s\n' "$active" "$occupied" >"$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
    pkill -RTMIN+8 waybar
}

# Seed the cache immediately so the bar is correct before the first event.
write_state

# Reconnect loop: if socat drops (e.g. Hyprland reloads), reconnect.
while true; do
    socat -u "UNIX-CONNECT:$SOCK" - 2>/dev/null | while read -r line; do
        case "$line" in
            workspace*|focusedmon*|openwindow*|closewindow*|movewindow*|createworkspace*|destroyworkspace*|activespecial*)
                write_state
                ;;
        esac
    done
    sleep 1
done
