#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
verify="$SCRIPT_DIR/verify_and_install.sh"

packages=("$@")

for pkg in "${packages[@]}"; do
	"$verify" "$pkg"
done
