#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="/opt/nvim"
BIN_LINK="/usr/local/bin/nvim"
TMP_DIR="$(mktemp -d)"
TARBALL_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "Downloading Neovim (stable, x86_64)..."
curl -L --fail "$TARBALL_URL" -o "$TMP_DIR/nvim.tar.gz"

echo "Installing Neovim..."
sudo rm -rf "$INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"
sudo tar -xzf "$TMP_DIR/nvim.tar.gz" -C "$INSTALL_DIR" --strip-components=1

sudo ln -sf "$INSTALL_DIR/bin/nvim" "$BIN_LINK"

echo "Neovim installed at $BIN_LINK"
nvim --version | head -n 1

