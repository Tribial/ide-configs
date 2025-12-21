#!/usr/bin/env bash
set -euo pipefail

OMZ_DIR="$HOME/.oh-my-zsh"
OMZ_REPO="https://github.com/ohmyzsh/ohmyzsh.git"

if [ ! -d "$OMZ_DIR/.git" ]; then
  echo "Installing Oh My Zsh..."
  git clone --depth=1 "$OMZ_REPO" "$OMZ_DIR"
else
  echo "Updating Oh My Zsh..."
  git -C "$OMZ_DIR" fetch origin
  git -C "$OMZ_DIR" pull --rebase --autostash
fi
