#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
run_list="$SCRIPT_DIR/../common/run_list.sh"

echo "Add microsoft packages =========================="
if ! dpkg -s packages-microsoft-prod >/dev/null 2>&1; then
  wget -q https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
  sudo dpkg -i /tmp/packages-microsoft-prod.deb
  rm /tmp/packages-microsoft-prod.deb
fi

packages=(
	"cowsay"
	"fortune"
	"fzf"
	"neovim"
	"ca-certificates"
	"dotnet-sdk-10.0"
	"dotnet-sdk-9.0"
	"build-essential"
	"libssl-dev"
	"curl"
	"nodejs"
	"npm"
    "zsh"
)
"$run_list" "${packages[@]}"


# npm stuff
