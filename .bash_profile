#!/usr/bin/env bash
BASH_DIR="${BASH_DIR:-$HOME/bash}"
CUSTOM_BASH_DIR="${CUSTOM_BASH_DIR:-$HOME/custom_bash}"
BASH_PROFILE_BEFORE="${BASH_PROFILE_BEFORE:-$CUSTOM_BASH_DIR/.bash_profile_before}"
BASH_PROFILE_AFTER="${BASH_PROFILE_AFTER:-$CUSTOM_BASH_DIR/.bash_profile_after}"
BASH_PROFILE_PLAIN="${BASH_PROFILE_PLAIN:-$CUSTOM_BASH_DIR/.bash_profile_plain}"
PS1_FLAG_USED=0
echo 'Running .bash_profile'
call_file() { [ -f "$1" ] && . "$1"; }
abp() {
 local saved_ps1="${PS1-}"; call_file "$BASH_PROFILE_BEFORE"
 [ -z "${T2F:-}" ] && echo 'Warning: $T2F is not set'
 . "$BASH_DIR/platform.sh"; . "$BASH_DIR/debug.sh"; . "$BASH_DIR/keys.sh"
 . "$BASH_DIR/git.sh"; . "$BASH_DIR/zip.sh"; . "$BASH_DIR/node.sh"; . "$BASH_DIR/java.sh"
 call_file "$BASH_PROFILE_AFTER"
 [ "$PS1_FLAG_USED" = 1 ] && PS1="$saved_ps1"; PS1_FLAG_USED=1
}
abp.go() { . "$BASH_DIR/go.sh"; }
abp.python() { . "$BASH_DIR/python.sh"; }
abp.docker() { . "$BASH_DIR/docker.sh"; }
abp.tmux() { . "$BASH_DIR/tmux.sh"; }
abp.sftp() { . "$BASH_DIR/sftp.sh"; }
abp.aws() { . "$BASH_DIR/aws.sh"; call_file "$CUSTOM_BASH_DIR/aws.sh"; }
abp.ssh() { . "$BASH_DIR/ssh.sh"; call_file "$CUSTOM_BASH_DIR/ssh.sh"; }
abp.nvm() { nvm.setup; }
abp.pyenv() { pyenv.setup; }
abp.qr() { python3 -m pip install --quiet qrcode pillow; }
abp.macos.port() { port.setup; }
abp.macos.brew() {
 [ "$(_platform)" = macos ] || { echo 'Homebrew loader is only available on macOS.' >&2; return 1; }
 local brew_bin
 for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$brew_bin" ] && eval "$("$brew_bin" shellenv)" && return
 done
 echo 'Homebrew was not found.' >&2; return 1
}
abp.all() {
 abp; abp.go; abp.python; abp.docker; abp.tmux; abp.sftp; abp.aws; abp.ssh
 command -v nvm >/dev/null 2>&1 && abp.nvm
 command -v pyenv >/dev/null 2>&1 && abp.pyenv
}
call_file "$BASH_PROFILE_PLAIN"
echo 'Finished .bash_profile - run abp to load dev tools'
