#!/usr/bin/env bash
# Time-of-day wallpaper cycler for the Tahoe Beach set.
#
# Usage:
#   tahoe-wallpaper.sh          set wallpaper for the current time and exit
#   tahoe-wallpaper.sh daemon   loop forever, switching on period change

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
STATE_FILE="${XDG_RUNTIME_DIR:-/tmp}/tahoe-wallpaper-period"
CHECK_INTERVAL=300 # seconds; short so suspend/resume catches up quickly

period_for_hour() {
    local hour=$1
    if ((hour >= 5 && hour < 8)); then
        echo Dawn
    elif ((hour >= 8 && hour < 17)); then
        echo Day
    elif ((hour >= 17 && hour < 20)); then
        echo Dusk
    else
        echo Night
    fi
}

apply() {
    local period force=$2
    period=$(period_for_hour "$((10#$(date +%H)))")
    if [[ $force != force && -f $STATE_FILE && $(<"$STATE_FILE") == "$period" ]]; then
        return
    fi
    awww img "$WALLPAPER_DIR/26-Tahoe-Beach-$period.jpg" \
        --transition-type fade --transition-duration 2 &&
        echo "$period" >"$STATE_FILE"
}

if [[ $1 == daemon ]]; then
    apply "" force
    while sleep "$CHECK_INTERVAL"; do
        apply
    done
else
    apply "" force
fi
