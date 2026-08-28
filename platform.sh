#!/usr/bin/env bash
_platform() {
 case "${OSTYPE:-}" in
  darwin*) echo macos ;;
  linux*) grep -qi microsoft /proc/version 2>/dev/null && echo wsl || echo linux ;;
  msys*|mingw*|cygwin*) echo windows ;;
  *) case "$(uname -s 2>/dev/null)" in Darwin) echo macos;; Linux) echo linux;; *) echo unknown;; esac ;;
 esac
}
bcopy() {
 case "$(_platform)" in
  macos) command pbcopy ;;
  windows|wsl) command clip.exe ;;
  linux)
   if command -v wl-copy >/dev/null 2>&1; then command wl-copy
   elif command -v xclip >/dev/null 2>&1; then command xclip -selection clipboard
   elif command -v xsel >/dev/null 2>&1; then command xsel --clipboard --input
   else echo 'No clipboard writer found (install wl-clipboard, xclip, or xsel).' >&2; return 127; fi ;;
  *) echo 'Clipboard copy is unsupported on this platform.' >&2; return 127 ;;
 esac
}
bpaste() {
 case "$(_platform)" in
  macos) command pbpaste ;;
  windows|wsl) powershell.exe -NoProfile -Command Get-Clipboard | sed 's/\r$//' ;;
  linux)
   if command -v wl-paste >/dev/null 2>&1; then command wl-paste --no-newline
   elif command -v xclip >/dev/null 2>&1; then command xclip -selection clipboard -out
   elif command -v xsel >/dev/null 2>&1; then command xsel --clipboard --output
   else echo 'No clipboard reader found (install wl-clipboard, xclip, or xsel).' >&2; return 127; fi ;;
  *) echo 'Clipboard paste is unsupported on this platform.' >&2; return 127 ;;
 esac
}
bopen() {
 case "$(_platform)" in
  macos) command open "$@" ;;
  linux) command xdg-open "$@" >/dev/null 2>&1 ;;
  wsl) command cmd.exe /c start '' "$(wslpath -w "$1")" >/dev/null 2>&1 ;;
  windows) command cmd.exe /c start '' "$1" >/dev/null 2>&1 ;;
  *) echo 'Open is unsupported on this platform.' >&2; return 127 ;;
 esac
}
breverse() { if command -v tac >/dev/null 2>&1; then command tac "$@"; else command tail -r "$@"; fi; }
bsed_in_place() {
 [ "$#" -ge 2 ] || { echo 'Usage: bsed_in_place <expression> <file...>' >&2; return 2; }
 local expression="$1"; shift
 if [ "$(_platform)" = macos ]; then sed -i '' -e "$expression" "$@"; else sed -i -e "$expression" "$@"; fi
}
port.setup() { [ -d /opt/local/bin ] && PATH="$PATH:/opt/local/bin"; export PATH; }
