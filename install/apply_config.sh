#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
#if [ -n "$BASH_SOURCE" ]; then
#elif [ -n "$ZSH_VERSION" ]; then
#	SCRIPT_PATH="$(realpath "${(%):-%N}")"
#else
#	echo "Unsupported shell"
#	exit 1
#fi
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_PATH")")"

declare -A SYMLINKS=(
	["$DOTFILES_DIR/ZSH/.zshrc"]="$HOME/.zshrc"
	["$DOTFILES_DIR/Zellij"]="$HOME/.config/zellij"
	["$DOTFILES_DIR/NeoVim"]="$HOME/.config/nvim"
	["$DOTFILES_DIR/ZSH/.zshenv"]="$HOME/.zshenv"
	["$DOTFILES_DIR/ZSH/.p10k.zsh"]="$HOME/.p10k.zsh"
	["$DOTFILES_DIR/sway"]="$HOME/.config/sway"
	["$DOTFILES_DIR/foot/foot.ini"]="$HOME/.config/foot/foot.ini"
	["$DOTFILES_DIR/Kitty/kitty.conf"]="$HOME/.config/kitty/kitty.conf"
	["$DOTFILES_DIR/waybar"]="$HOME/.config/waybar"
	["$DOTFILES_DIR/Wofi/style.css"]="$HOME/.config/wofi/style.css"
)

declare -A SUDO_SYMLINKS=(
	["$DOTFILES_DIR/greetd/config.toml"]="/etc/greetd/config.toml"
)

create_symlink() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        echo "Replacing symlink: $dest"
        rm "$dest"
        ln -s "$src" "$dest"
        echo "Replaced symlink: $dest -> $src"

    elif [ -e "$dest" ]; then
        echo "$dest exists and is not a symlink. Removing it."
        rm -rf "$dest"
        ln -s "$src" "$dest"
        echo "Creates new symlink: $dest -> $src"
    else
        echo "Creating symlink: $dest"
        ln -s "$src" "$dest"
        echo "Creates new symlink: $dest -> $src"
    fi
}

sudo_create_symlink() {
	local src="$1"
	local dest="$2"

	if [ -L "$dest" ]; then
		echo "Replacing symlink: $dest"
		sudo rm "$dest"
		sudo ln -s "$src" "$dest"
		echo "Replaced symlink: $dest -> $src"

	elif [ -e "$dest" ]; then
		echo "$dest exists and is not a symlink. Removing it."
		sudo rm -rf "$dest"
		sudo ln -s "$src" "$dest"
		echo "Creates new symlink: $dest -> $src"
	else
		echo "Creating symlink: $dest"
		sudo ln -s "$src" "$dest"
		echo "Creates new symlink: $dest -> $src"
	fi
}

mkdir -p "$HOME/.config/sway"
mkdir -p "$HOME/.config/foot"
mkdir -p "$HOME/.config/wofi"
for src in "${!SYMLINKS[@]}"; do
    dest="${SYMLINKS[$src]}"
    create_symlink "$src" "$dest"
done

for src in "${!SUDO_SYMLINKS[@]}"; do
	dest="${SUDO_SYMLINKS[$src]}"
	sudo_create_symlink "$src" "$dest"
done

echo "Config symlinks applied."
