#!/usr/bin/env bash
set -euo pipefail

pkg="$1"

if dpkg -s "$pkg" >/dev/null 2>&1; then
	echo "[INFO] Updating: $pkg"
	sudo apt-get install --only-upgrade -y "$pkg"
else
	echo "[INFO] Installing: $pkg"
	sudo apt-get install -y "$pkg"
fi
