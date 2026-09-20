nvm.setup() {
 export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
 [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
 [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}

function npm.use.empty() {
  if [ -f "$HOME/.npmrc" ] && [ -s "$HOME/.npmrc" ]; then
    mv "$HOME/.npmrc" "$HOME/.npmrc.with.credentials"
    touch "$HOME/.npmrc"
    echo "Moved .npmrc to .npmrc.with.credentials and created an empty .npmrc"
  else
    echo ".npmrc does not exist or is already empty"
  fi
}

function npm.use.with.credentials() {
  if [ -f "$HOME/.npmrc.with.credentials" ] && [ -s "$HOME/.npmrc.with.credentials" ]; then
    mv "$HOME/.npmrc.with.credentials" "$HOME/.npmrc"
    echo "Reverted .npmrc.with.credentials to .npmrc"
  else
    echo ".npmrc.with.credentials does not exist or is empty"
  fi
}
