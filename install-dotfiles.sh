#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles..."
echo "This will symlink files from $DOTFILES_DIR into your home directory."
echo "Existing files will be backed up with a .bak suffix."
echo ""

install_symlinks() {
    local src="$1"
    local dest="$2"
    local name="$3"

    mkdir -p "$dest"

    for item in "$src"/* "$src"/.*; do
        base="$(basename "$item")"
        [ "$base" = "." ] || [ "$base" = ".." ] && continue
        [ "$base" = ".gitignore" ] && continue
        [ "$base" = "push-dotfiles.sh" ] && continue
        [ "$base" = "install-dotfiles.sh" ] && continue
        [ -e "$item" ] || continue

        target="$dest/$base"

        if [ -e "$target" ] && [ ! -L "$target" ]; then
            echo "Backing up $target -> $target.bak"
            mv "$target" "$target.bak"
        fi

        if [ -L "$target" ]; then
            rm "$target"
        fi

        echo "Linking $item -> $target"
        ln -sf "$item" "$target"
    done
}

install_symlinks "$DOTFILES_DIR/config" "$HOME/.config" ".config"
install_symlinks "$DOTFILES_DIR/scripts" "$HOME/.scripts" ".scripts"

mkdir -p "$HOME/Pictures/Wallpapers"
for item in "$DOTFILES_DIR/wallpapers"/*; do
    [ -e "$item" ] || continue
    base="$(basename "$item")"
    target="$HOME/Pictures/Wallpapers/$base"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target -> $target.bak"
        mv "$target" "$target.bak"
    fi

    if [ -L "$target" ]; then
        rm "$target"
    fi

    echo "Linking $item -> $target"
    ln -sf "$item" "$target"
done

echo ""
echo "Dotfiles installed successfully!"
