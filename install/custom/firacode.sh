#!/usr/bin/env bash
set -euo pipefail

FONT_DIR="$HOME/.local/share/fonts/FiraCodeNerdFont"
ZIP="$FONT_DIR/FiraCode.zip"
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"

mkdir -p "$FONT_DIR"

wget -O "$ZIP" "$URL"
unzip -o "$ZIP" -d "$FONT_DIR"
rm "$ZIP"

fc-cache -f "$FONT_DIR"
