#!/usr/bin/env bash
set -u
BASH_DIR="${BASH_DIR:-$HOME/bash}"
link_file() {
    local src="$1" dst="$2"
    if [ -e "$dst" ] || [ -L "$dst" ]; then echo "EXISTS  $dst — skipping"
    else ln -s "$src" "$dst" && echo "LINKED  $dst -> $src"; fi
}
echo '=== Setting up symlinks ==='
link_file "$BASH_DIR/.bash_profile" "$HOME/.bash_profile"
link_file "$BASH_DIR/.tmux.conf" "$HOME/.tmux.conf"
echo 'Open a new terminal (or source ~/.bash_profile), then run: abp'
