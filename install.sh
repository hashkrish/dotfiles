#!/usr/bin/env bash

# Create .config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Create symlinks for all directories in .config
for dir in "$PWD"/.config/*; do
    # If directory exists, move it to a backup
    if [[ -d "$HOME/.config/$(basename $dir)" ]]; then
        mv "$HOME/$dir" "$HOME/${dir}_bkp"
    fi

    # Create symlink
    ln -s "$dir" "$HOME/.config/$(basename $dir)"
done

for file in .*; do
    # Skip files
    if [[ "$file" == ".config" || "$file" == ".git" || "$file" == ".gitignore" ]]; then
        continue
    fi

    # If file exists, move it to a backup
    if [[ -a "$HOME/$file" ]]; then
        mv "$HOME/$file" "$HOME/${file}_bkp"
    fi

    # Create symlink
    ln -s "$PWD/$file" "$HOME"
done
