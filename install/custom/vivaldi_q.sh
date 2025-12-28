#!/usr/bin/env bash
set -euo pipefail

if dpkg -s vivaldi-stable >/dev/null 2>&1; then
    echo "Vivaldi is installed."
else
    cat <<'EOF'

┌──────────────────────────────────────────────────────────────┐
│  ⚠  VIVALDI IS NOT INSTALLED                                 │
│                                                              │
│  Vivaldi is not installed, since it's run with -q,           │
│  it will not be installed.                                   │
│                                                              │
└──────────────────────────────────────────────────────────────┘

EOF
    exit 1
fi
