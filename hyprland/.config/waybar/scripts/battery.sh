#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT0"
AC_PATH="/sys/class/power_supply/AC"

capacity=$(cat "$BAT_PATH/capacity" 2>/dev/null || echo 0)
status=$(cat "$BAT_PATH/status" 2>/dev/null || echo "Unknown")
ac_online=$(cat "$AC_PATH/online" 2>/dev/null || echo 0)
profile=$(cat /sys/firmware/acpi/platform_profile 2>/dev/null || echo "unknown")

# Power draw in W
power_uw=$(cat "$BAT_PATH/power_now" 2>/dev/null || echo 0)
power_w=$(awk "BEGIN {printf \"%.1f\", $power_uw / 1000000}")

# Time remaining
time_str=""
if [ "$status" = "Discharging" ] && [ "$power_uw" -gt 0 ]; then
    energy_now=$(cat "$BAT_PATH/energy_now")
    mins=$(awk "BEGIN {printf \"%d\", $energy_now * 60 / $power_uw}")
    hours=$((mins / 60))
    mins=$((mins % 60))
    time_str="$(printf '%dh %02dm remaining' $hours $mins)"
elif [ "$status" = "Charging" ] && [ "$power_uw" -gt 0 ]; then
    energy_now=$(cat "$BAT_PATH/energy_now")
    energy_full=$(cat "$BAT_PATH/energy_full")
    energy_left=$((energy_full - energy_now))
    mins=$(awk "BEGIN {printf \"%d\", $energy_left * 60 / $power_uw}")
    hours=$((mins / 60))
    mins=$((mins % 60))
    time_str="$(printf '%dh %02dm until full' $hours $mins)"
elif [ "$status" = "Full" ]; then
    time_str="Fully charged"
fi

# Icon
if [ "$status" = "Full" ]; then
    icon="󰁹"
elif [ "$status" = "Charging" ] || [ "$ac_online" = "1" ]; then
    icon="󰂄"
else
    if   [ "$capacity" -le 10 ]; then icon="󰁺"
    elif [ "$capacity" -le 30 ]; then icon="󰁻"
    elif [ "$capacity" -le 50 ]; then icon="󰁼"
    elif [ "$capacity" -le 80 ]; then icon="󰁽"
    else icon="󰁾"
    fi
fi

# Power profile
case $profile in
    performance) profile_str="⚡ Performance" ;;
    balanced)    profile_str="󰗑 Balanced" ;;
    low-power)   profile_str="󰁹 Power Saver" ;;
    *)           profile_str="$profile" ;;
esac

# CSS class
if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
    css_class="charging"
elif [ "$capacity" -le 15 ]; then
    css_class="critical"
elif [ "$capacity" -le 30 ]; then
    css_class="warning"
else
    css_class=""
fi

tooltip="${time_str}\n${power_w} W\n${profile_str}"

echo "{\"text\": \"${icon} ${capacity}%\", \"tooltip\": \"${tooltip}\", \"class\": \"${css_class}\", \"percentage\": ${capacity}}"
