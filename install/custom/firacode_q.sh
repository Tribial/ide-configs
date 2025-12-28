#!/usr/bin/env bash
set -euo pipefail

if fc-list | grep -qi "FiraCode"; then
    echo "FiraCode is installed."
else
    cat <<'EOF'

┌──────────────────────────────────────────────────────────────┐
│  ⚠  FIRACODE IS NOT INSTALLED                                │
│                                                              │
│  FiraCode is not installed, since it's run with -q,          │
│  it will not be installed.                                   │
│                                                              │
└──────────────────────────────────────────────────────────────┘

EOF
    exit 1
fi
