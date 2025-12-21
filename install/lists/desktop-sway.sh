#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
run_list="$SCRIPT_DIR/../common/run_list.sh"

packages=(
	"sway"
	"swaybg"
	"swaylock"
	"swayidle"

	"seatd"
	"wayland-utils"
	"wl-clipboard"
	#screen shot
	"grim"
	#snip for screen shot
	"slurp"

	"wofi"
	"brightnessctl"
	"playerctl"
	"waybar"
	"mako-notifier"
	
	"pipewire"
	"pipewire-audio"
	"pipewire-pulse"
	"pipewire-alsa"
	"pipewire-jack"
	"wireplumber"
	"pulseaudio-utils"

	"network-manager"

	#should remove, nice but doesn't support ligatures
	"foot"
	"kitty"
	
	"greetd"
	"tuigreet"
	"unzip"
)
"$run_list" "${packages[@]}"
