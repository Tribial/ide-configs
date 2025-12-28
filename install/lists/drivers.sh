#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
run_list="$SCRIPT_DIR/../common/run_list.sh"

packages=(
	# GPU firmware
	"firmware-amd-graphics"
	
	# OpenGL tools
	"mesa-utils"

	# Vulkan drivers for AMD
	"mesa-vulkan-drivers"

	"vulkan-tools"
)
"$run_list" "${packages[@]}"
