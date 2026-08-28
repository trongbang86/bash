#!/usr/bin/env bash
set -euo pipefail

BASH_REPO_URL="${BASH_REPO_URL:-https://github.com/trongbang86/bash.git}"
BASH_DIR="${BASH_DIR:-$HOME/bash}"
CUSTOM_BASH_DIR="${CUSTOM_BASH_DIR:-$HOME/custom_bash}"
BASH_UPDATE="${BASH_UPDATE:-1}"

say() { printf '%-8s %s\n' "$1" "$2"; }
fail() { printf 'ERROR: %s\n' "$1" >&2; exit 1; }

install_or_update_repo() {
    command -v git >/dev/null 2>&1 || fail 'git is required'

    if [ -d "$BASH_DIR/.git" ]; then
        if [ "$BASH_UPDATE" = 1 ]; then
            say UPDATE "$BASH_DIR"
            git -C "$BASH_DIR" pull --ff-only
        else
            say EXISTS "$BASH_DIR (update disabled)"
        fi
        return
    fi

    if [ -e "$BASH_DIR" ]; then
        [ -d "$BASH_DIR" ] || fail "$BASH_DIR exists and is not a directory"
        [ -z "$(ls -A "$BASH_DIR")" ] || fail "$BASH_DIR exists, is nonempty, and is not a Git checkout"
        rmdir "$BASH_DIR"
    fi

    mkdir -p "$(dirname "$BASH_DIR")"
    say CLONE "$BASH_REPO_URL -> $BASH_DIR"
    git clone "$BASH_REPO_URL" "$BASH_DIR"
}

install_custom_template() {
    local template="$BASH_DIR/custom_bash" source relative destination
    [ -d "$template" ] || fail "custom template not found at $template"
    mkdir -p "$CUSTOM_BASH_DIR"

    while IFS= read -r -d '' source; do
        relative=${source#"$template"/}
        destination="$CUSTOM_BASH_DIR/$relative"
        if [ -d "$source" ]; then
            mkdir -p "$destination"
        elif [ -e "$destination" ] || [ -L "$destination" ]; then
            say EXISTS "$destination"
        else
            mkdir -p "$(dirname "$destination")"
            cp -pP "$source" "$destination"
            say CREATED "$destination"
        fi
    done < <(find "$template" -mindepth 1 -print0)
}

link_file() {
    local source="$1" destination="$2"
    if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$source" ]; then
        say EXISTS "$destination -> $source"
    elif [ -e "$destination" ] || [ -L "$destination" ]; then
        say SKIP "$destination already exists"
    else
        ln -s "$source" "$destination"
        say LINKED "$destination -> $source"
    fi
}

ensure_bashrc_loader() {
    local bashrc="$HOME/.bashrc" marker='# bash-scaffold profile loader'
    if [ ! -e "$bashrc" ] && [ ! -L "$bashrc" ]; then
        link_file "$BASH_DIR/.bashrc" "$bashrc"
    elif [ -L "$bashrc" ]; then
        if [ "$(readlink "$bashrc")" = "$BASH_DIR/.bashrc" ]; then
            say EXISTS "$bashrc loads the bash scaffold"
        else
            say SKIP "$bashrc is an existing symlink"
        fi
    elif grep -Fq "$marker" "$bashrc" 2>/dev/null; then
        say EXISTS "$bashrc loads the bash scaffold"
    else
        local backup="$bashrc.bash-scaffold-backup.$(date +%Y%m%d%H%M%S)"
        cp -pP "$bashrc" "$backup"
        printf '\n%s\n[ -f "$HOME/.bash_profile" ] && . "$HOME/.bash_profile"\n' "$marker" >>"$bashrc"
        say BACKUP "$backup"
        say UPDATED "$bashrc"
    fi
}

install_or_update_repo
install_custom_template
link_file "$BASH_DIR/.bash_profile" "$HOME/.bash_profile"
link_file "$BASH_DIR/.tmux.conf" "$HOME/.tmux.conf"
ensure_bashrc_loader

printf '\nSetup complete. Open a new terminal, then run: abp\n'
