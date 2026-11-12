#!/bin/bash
############################
# makesymlinks.sh
# Creates symlinks from the home directory to the dotfiles in this repo.
# Safe to re-run: existing correct links are left alone, anything else is
# moved to a timestamped backup folder first.
############################

########## Variables

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # this repo, wherever it's cloned
olddir="$HOME/dotfiles_old/$(date +%Y%m%d-%H%M%S)"    # backup folder for this run
files="zshrc bashrc bash_aliases vim oh-my-posh tmux.conf"       # files/folders to symlink in ~

##########

backed_up=0
for file in $files; do
    target="$HOME/.$file"
    source="$dir/$file"

    if [ ! -e "$source" ]; then
        echo "Skipping $file: not found in $dir"
        continue
    fi

    # Already linked to the right place: nothing to do
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "~/.$file already linked, skipping."
        continue
    fi

    # Anything else in the way (file, folder or other link): back it up
    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$olddir"
        echo "Backing up existing ~/.$file to $olddir/"
        mv "$target" "$olddir/"
        backed_up=1
    fi

    echo "Linking ~/.$file -> $source"
    ln -sn "$source" "$target"
done

# Scripts in bin/ go into ~/.local/bin (already on PATH in zshrc)
mkdir -p "$HOME/.local/bin"
for script in "$dir"/bin/*; do
    [ -f "$script" ] || continue
    chmod +x "$script"
    echo "Linking ~/.local/bin/$(basename "$script") -> $script"
    ln -sfn "$script" "$HOME/.local/bin/$(basename "$script")"
done

[ "$backed_up" = 1 ] && echo "Backups are in $olddir"
exit 0
