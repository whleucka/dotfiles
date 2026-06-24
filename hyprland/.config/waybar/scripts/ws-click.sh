#!/bin/bash
# Handle a Waybar workspace-button click.
# Usage: ws-click.sh <workspace-number>
#
# Switches workspace via the Lua dispatcher (the native Waybar workspaces module
# can't be used here: it sends a raw `dispatch workspace N` which this machine's
# Lua Hyprland config can't parse). Then optimistically marks the clicked
# workspace active in the cache and signals Waybar, so the highlight repaints
# instantly instead of waiting for the event listener's round-trip.

ws="$1"
CACHE="${XDG_RUNTIME_DIR:-/tmp}/waybar-ws.state"

hyprctl dispatch "hl.dsp.focus({ workspace = $ws })" >/dev/null 2>&1

# Optimistic update: only `active` changes on a focus switch; keep occupied as-is.
# (The listener will reconcile shortly after via the socket2 event.)
occupied=""
if [ -r "$CACHE" ]; then
    while read -r key val; do
        [ "$key" = "occupied" ] && occupied="$val"
    done <"$CACHE"
    printf 'active %s\noccupied %s\n' "$ws" "$occupied" >"$CACHE.tmp" && mv "$CACHE.tmp" "$CACHE"
fi

pkill -RTMIN+8 waybar
