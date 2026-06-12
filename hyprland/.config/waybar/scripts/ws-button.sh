#!/bin/bash
# Emits Waybar JSON for a single workspace button.
# Usage: ws-button.sh <workspace-number> [mode]
#   mode = "always" (default) -> always shown
#   mode = "auto"             -> hidden (empty output) unless active or occupied
# class is "active" when focused, "occupied" when it has windows, else "empty".

ws="$1"
mode="${2:-always}"

active=$(hyprctl activeworkspace -j | jq -r '.id')
windows=$(hyprctl workspaces -j | jq -r --argjson id "$ws" '.[] | select(.id == $id) | .windows' 2>/dev/null)
windows=${windows:-0}

if [ "$active" = "$ws" ]; then
    class="active"
elif [ "$windows" -gt 0 ]; then
    class="occupied"
else
    class="empty"
fi

# Auto mode: collapse the button (empty text => Waybar hides it) when nothing's there.
if [ "$mode" = "auto" ] && [ "$class" = "empty" ]; then
    printf '{"text": "", "class": "empty", "tooltip": ""}\n'
    exit 0
fi

# Display label: workspace 10 shows as "0".
label="$ws"
[ "$ws" -eq 10 ] && label="0"

printf '{"text": "%s", "class": "%s", "tooltip": "Workspace %s"}\n' "$label" "$class" "$ws"
