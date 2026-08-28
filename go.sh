export GOPATH="${GOPATH:-$HOME/go}"
case ":$PATH:" in *":$GOPATH/bin:"*) ;; *) PATH="$PATH:$GOPATH/bin";; esac
export PATH
