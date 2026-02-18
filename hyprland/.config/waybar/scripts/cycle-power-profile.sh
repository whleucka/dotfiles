#!/bin/bash
current=$(cat /sys/firmware/acpi/platform_profile)
case $current in
    performance) next="balanced" ;;
    balanced)    next="power-saver" ;;
    *)           next="performance" ;;
esac
sudo tlp $next
