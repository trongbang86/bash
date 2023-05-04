alias vim.python.pip.conf='vim ~/.pip/pip.conf'

function python3.venv() {
  python3 -m venv .venv
  source .venv/bin/activate
  which python3
}

function python2.virtualenv() {
  python2 -m virtualenv .venv
  source .venv/bin/activate
  which python2
}
