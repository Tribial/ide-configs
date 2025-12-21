#!/usr/bin/env bash
set -euo pipefail

if ! command -v zsh >/dev/null 2>&1; then
    cat <<'EOF'

┌──────────────────────────────────────────────────────────────┐
│  ⚠  ZSH NOT AVAILABLE IN CURRENT ENVIRONMENT                 │
│                                                              │
│  zsh is not in PATH. If you just installed it,               │
│  restart your shell or log out and back in.                  │
│                                                              │
│  This script will not continue.                              │
└──────────────────────────────────────────────────────────────┘

EOF
    exit 1
fi

TARGET="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
REPO="https://github.com/romkatv/powerlevel10k.git"

if [ -d "$TARGET/.git" ]; then
    git -C "$TARGET" pull --ff-only
else
    git clone --depth=1 "$REPO" "$TARGET"
fi
