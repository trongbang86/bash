# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/bang.nguyen/.docker/bin"
# End of Docker Desktop section.

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
abp.docker() { . "$BASH_DIR/docker.sh"; call_file "$CUSTOM_BASH_DIR/docker.sh"; }
abp.k8s() { . "$BASH_DIR/k8s.sh"; call_file "$CUSTOM_BASH_DIR/k8s.sh"; }
abp.dotnet() { . "$BASH_DIR/dotnet.sh"; call_file "$CUSTOM_BASH_DIR/dotnet.sh"; }
abp.tmux() { . "$BASH_DIR/tmux.sh"; }
abp.sftp() { . "$BASH_DIR/sftp.sh"; }
abp.aws() { . "$BASH_DIR/aws.sh"; call_file "$CUSTOM_BASH_DIR/aws.sh"; }
abp.ssh() { . "$BASH_DIR/ssh.sh"; call_file "$CUSTOM_BASH_DIR/ssh.sh"; }
abp.nvm() { nvm.setup; }
abp.pyenv() { pyenv.setup; }
abp.qr() { python3 -m pip install --quiet qrcode pillow; }
abp.ai() { . "$BASH_DIR/ai.sh"; call_file "$CUSTOM_BASH_DIR/ai.sh"; }
abp.sdk() { . "$BASH_DIR/sdk.sh"; }
abp.rust() { . "$BASH_DIR/rust.sh"; call_file "$CUSTOM_BASH_DIR/rust.sh"; }
abp.macos() { . "$BASH_DIR/macos.sh"; }
abp.temporal() { . "$BASH_DIR/temporal.sh"; }
abp.backup() { call_file "$CUSTOM_BASH_DIR/backup.env.sh"; . "$BASH_DIR/backup.sh"; }
abp.toggle() {
  (( ${#ABP_TOGGLE_CMDS[@]} )) || { echo 'ABP_TOGGLE_CMDS not set — run abp first, or define it in custom_bash/common.env.sh' >&2; return 1; }
  python3 "$BASH_DIR/resources/abp_toggle.py" "$BASH_DIR/.bash_profile" "${ABP_TOGGLE_CMDS[@]}"
}
abp.all() {
 abp; abp.go; abp.python; abp.docker; abp.tmux; abp.sftp; abp.aws; abp.ssh
 command -v nvm >/dev/null 2>&1 && abp.nvm
 command -v pyenv >/dev/null 2>&1 && abp.pyenv
}
call_file "$BASH_PROFILE_PLAIN"
echo 'Finished .bash_profile - run abp to load dev tools'
