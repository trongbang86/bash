docker.require() { command -v docker >/dev/null 2>&1 || { echo 'docker was not found.' >&2; return 127; }; }
