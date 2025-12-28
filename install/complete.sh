#!/usr/bin/env bash
set -euo pipefail

QUICK=0

for arg in "$@"; do
    case "$arg" in
        -q|--quick)
            QUICK=1
            ;;
        *)
            ;;
    esac
done

run_with_quick() {
    local script="$1"
    local scriptWithQ="$2"
    shift

    if [ "${QUICK:-0}" -eq 1 ]; then
        "$scriptWithQ" "$@"
    else
        "$script" "$@"
    fi
}

# 1. Most important: run updates
sudo apt update && sudo apt full-upgrade -y

# 2. Make scripts executable
chmod +x common/*.sh
chmod +x lists/*.sh
chmod +x custom/*.sh

# 3. Install tool sets:
./lists/drivers.sh
./lists/desktop-sway.sh
	# after this:
	sudo systemctl enable --now NetworkManager
	systemctl --user enable --now wireplumber
	sudo systemctl enable greetd
./lists/terminal-tools.sh
    # after this:
    chsh -s /usr/bin/zsh
    sudo npm install -g markdownlint-cli
# 4. Custom install scripts:
echo "FiraCode ==========================================================="
run_with_quick ./custom/firacode.sh ./custom/firacode_q.sh
echo "Vivaldi ============================================================"
run_with_quick ./custom/vivaldi.sh ./custom/vivaldi_q.sh
echo "Oh My ZSH =========================================================="
./custom/omz.sh
echo "Zellij ============================================================="
./custom/zellij.sh
echo "PL10K =============================================================="
./custom/powerlevel10k.sh
echo "ZSH automcplete ===================================================="
./custom/powerlevel10k.sh
