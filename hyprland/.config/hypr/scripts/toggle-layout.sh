#!/usr/bin/env bash
# Toggle between dwindle and monocle. Uses `hyprctl dispatch` with a Lua
# `hl.config` call because `hyprctl keyword` no longer works under the Lua
# parser (0.55+). The dispatch wrapper prints an error after the call, but
# the layout change lands as a side effect — stderr is discarded.

cur=$(hyprctl getoption general:layout -j | jq -r '.str')
if [ "$cur" = "dwindle" ]; then
    next="monocle"
else
    next="dwindle"
fi

hyprctl dispatch "hl.config({ general = { layout = \"$next\" } })" >/dev/null 2>&1
