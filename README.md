# bash scaffold

Portable Bash setup for macOS, Linux, WSL, and Git Bash.

## Quick start

```bash
curl -fsSL https://raw.githubusercontent.com/trongbang86/bash/master/init.sh | bash
# Open a new terminal, then:
abp
```

The installer:

- clones this repository to `~/bash`, or fast-forwards an existing checkout;
- creates `~/custom_bash` and copies only missing template files, preserving
  local settings and functions;
- links `~/.bash_profile` and `~/.tmux.conf` when they do not already exist;
- makes interactive non-login shells load the profile through `~/.bashrc`,
  backing up an existing `.bashrc` before changing it.

The installer is safe to run again after upstream updates. Machine-specific
settings belong in `~/custom_bash`.

To use different locations or a fork:

```bash
curl -fsSL https://raw.githubusercontent.com/trongbang86/bash/master/init.sh | \
  BASH_REPO_URL=https://github.com/you/bash.git \
  BASH_DIR="$HOME/path/to/bash" \
  CUSTOM_BASH_DIR="$HOME/path/to/custom_bash" bash
```

Set `BASH_UPDATE=0` to configure files and links without updating an existing
checkout.

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
