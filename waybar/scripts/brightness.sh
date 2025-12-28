#!/bin/bash

BACKLIGHT="amdgpu_bl0" # check your backlight name in /sys/class/backlight/
BRIGHT=$(brightnessctl -d $BACKLIGHT g)
MAX=$(brightnessctl -d $BACKLIGHT m)
PERCENT=$(( BRIGHT * 100 / MAX ))

echo "BRI ${PERCENT}%"

