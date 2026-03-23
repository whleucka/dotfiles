#!/usr/bin/env bash
# Start/stop hypridle based on AC power state.
# On battery: start hypridle. On AC: stop hypridle.

AC_PATH="/sys/class/power_supply/AC/online"

start_idle() {
    if ! pidof hypridle > /dev/null; then
        hypridle &
        disown
    fi
}

stop_idle() {
    pkill hypridle 2>/dev/null
}

update() {
    if [[ "$(cat "$AC_PATH")" == "0" ]]; then
        start_idle
    else
        stop_idle
    fi
}

# Set initial state
update

# Monitor for power supply changes
upower --monitor | while read -r line; do
    if [[ "$line" == *"AC"* || "$line" == *"line-power"* || "$line" == *"on-battery"* ]]; then
        sleep 1
        update
    fi
done
