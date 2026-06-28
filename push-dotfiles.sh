#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Updating dotfiles from home directory..."

# Sync configs (preserve .gitignore exclusions)
rsync -a --delete --exclude-from="$DOTFILES_DIR/.gitignore" "$HOME/.config/" "$DOTFILES_DIR/config/"

# Sync scripts
rsync -a --delete "$HOME/.scripts/" "$DOTFILES_DIR/scripts/"

# Sync wallpapers
rsync -a --delete "$HOME/Pictures/Wallpapers/" "$DOTFILES_DIR/wallpapers/"

echo "Committing changes..."
cd "$DOTFILES_DIR"

if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    git add -A
    git commit -m "Update dotfiles: $(date '+%Y-%m-%d %H:%M')"
    git push
    echo "Pushed successfully."
else
    echo "No changes to commit."
fi

echo "Proceeding to nuke..."
"$HOME/.scripts/nuke.sh"
