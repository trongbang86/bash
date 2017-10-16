export PS1LONG="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[36m\][$(date +%H:%M:%S)]\[\033[m\] \$ "
export PS1SHORT="\[\033[33;1m\]\W\[\033[m\] \$ "
export PS1="$PS1LONG"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias 'pbl=pbpaste | less'
