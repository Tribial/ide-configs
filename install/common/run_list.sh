#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
verify="$SCRIPT_DIR/verify_and_install.sh"

packages=("$@")

sudo apt update
echo "===================================================================="
for pkg in "${packages[@]}"; do
	"$verify" "$pkg"
done
echo "===================================================================="
