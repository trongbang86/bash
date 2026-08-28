# bash scaffold

Portable Bash setup for macOS, Linux, WSL, and Git Bash.

## Quick start

```bash
git clone <this-repo> ~/bash
bash ~/bash/init.sh
# Open a new terminal, then:
abp
```

Machine-specific settings belong in `~/custom_bash`. Override `BASH_DIR` and
`CUSTOM_BASH_DIR` if the repositories live elsewhere.

## Optional loaders

`abp` loads the portable core. Use `abp.go`, `abp.python`, `abp.docker`,
`abp.tmux`, `abp.sftp`, `abp.aws`, or `abp.ssh` on demand. `abp.all`
loads all available groups.

## Platform layer

`platform.sh` provides:

| Function | macOS | Linux | WSL / Git Bash |
|---|---|---|---|
| `bcopy` | `pbcopy` | Wayland, `xclip`, or `xsel` | `clip.exe` |
| `bpaste` | `pbpaste` | Wayland, `xclip`, or `xsel` | PowerShell |
| `bopen` | `open` | `xdg-open` | `cmd.exe /c start` |
| `breverse` | `tail -r` fallback | `tac` | `tac` |

Clipboard and Git helpers use these functions instead of OS-specific commands.
