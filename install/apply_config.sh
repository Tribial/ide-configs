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
    ["$DOTFILES_DIR/Kitty/kitty.conf"]="$HOME/.config/kitty/kitty.conf"
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

for src in "${!SYMLINKS[@]}"; do
    dest="${SYMLINKS[$src]}"
    create_symlink "$src" "$dest"
done

echo "Config symlinks applied."
