python3.venv() { python3 -m venv .venv && . .venv/bin/activate; }
pyenv.setup() {
 export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
 [ -d "$PYENV_ROOT/bin" ] && PATH="$PYENV_ROOT/bin:$PATH"
 command -v pyenv >/dev/null 2>&1 || { echo 'pyenv was not found.' >&2; return 127; }
 eval "$(pyenv init -)"
}
