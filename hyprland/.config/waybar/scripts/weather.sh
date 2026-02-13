#!/bin/bash

CACHE_FILE="/tmp/waybar-weather-cache"
TOOLTIP_CACHE="/tmp/waybar-weather-tooltip-cache"
CACHE_MAX_AGE=900  # 15 minutes in seconds

# Function to escape string for JSON
json_escape() {
    echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | awk '{printf "%s\\n", $0}' | sed '$ s/\\n$//'
}

# Function to fetch weather
fetch_weather() {
    curl -s --max-time 10 'wttr.in/?format=%c%t' | tr -s ' '
}

# Function to fetch weather tooltip (more detailed)
fetch_tooltip() {
    curl -s --max-time 10 'wttr.in/?format=%l:+%C,+feels+like+%f\n%w+wind\n%h+humidity\n%p+pressure' | head -4
}

# Check if cache exists and is recent
if [ -f "$CACHE_FILE" ]; then
    cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
    if [ $cache_age -lt $CACHE_MAX_AGE ]; then
        text=$(cat "$CACHE_FILE")
        tooltip=$(cat "$TOOLTIP_CACHE" 2>/dev/null || echo "Weather information")
        tooltip_escaped=$(json_escape "$tooltip")
        printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip_escaped"
        exit 0
    fi
fi

# Try to fetch weather
weather=$(fetch_weather)
tooltip=$(fetch_tooltip)

# If successful, update cache and display
if [ -n "$weather" ] && [ "$weather" != " " ]; then
    echo "$weather" > "$CACHE_FILE"
    echo "$tooltip" > "$TOOLTIP_CACHE"
    tooltip_escaped=$(json_escape "$tooltip")
    printf '{"text":"%s","tooltip":"%s"}\n' "$weather" "$tooltip_escaped"
    exit 0
fi

# If fetch failed, try to use cached data (even if old)
if [ -f "$CACHE_FILE" ]; then
    text=$(cat "$CACHE_FILE")
    tooltip=$(cat "$TOOLTIP_CACHE" 2>/dev/null || echo "Weather information")
    tooltip_escaped=$(json_escape "$tooltip")
    printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip_escaped"
    exit 0
fi

# Last resort: show a placeholder
printf '{"text":"🌡️ --°","tooltip":"Weather unavailable"}\n'
