#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
BIN="$BIN_DIR/zellij"
TMP="$(mktemp -d)"
ARCH="x86_64-unknown-linux-musl"

LATEST_URL="https://github.com/zellij-org/zellij/releases/latest/download/zellij-${ARCH}.tar.gz"

mkdir -p "$BIN_DIR"

curl -fsSL "$LATEST_URL" | tar -xz -C "$TMP"
install -m 755 "$TMP/zellij" "$BIN"

rm -rf "$TMP"
