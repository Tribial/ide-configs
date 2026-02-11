#!/usr/bin/env bash

options="Shutdown\nReboot\nSleep\nLock\nLogout"

choice=$(printf "$options" | wofi --dmenu -i --prompt "Power")

case "$choice" in
    Shutdown) systemctl poweroff ;;
    Reboot)   systemctl reboot ;;
    Sleep)    systemctl suspend ;;
    Lock)     ~/.config/sway/scripts/lock.sh ;;
    Logout)   swaymsg exit ;;
esac
