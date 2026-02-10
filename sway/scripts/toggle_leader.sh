#!/usr/bin/env bash

FILE="$HOME/.config/sway/leader.conf"

current=$(grep -oE 'Mod4|Scroll_Lock' "$FILE")

if [ "$current" = "Mod4" ]; then
    echo 'set $mod Scroll_Lock' > "$FILE"
    swaymsg reload
    notify-send -t 5000 "Leader switched to Scroll_Lock"
else
    echo 'set $mod Mod4' > "$FILE"
    swaymsg reload
    notify-send -t 5000 "Leader switched to Mod4"
fi


