function dotnet.sdk.8() {
  export DOTNET_ROOT="$(brew --prefix dotnet@8)/libexec"
  export PATH="$DOTNET_ROOT:$HOME/.dotnet/tools:$PATH"
  dotnet --version
}

function dotnet.sdk.10() {
  export DOTNET_ROOT="$(brew --prefix dotnet)/libexec"
  export PATH="$DOTNET_ROOT:$HOME/.dotnet/tools:$PATH"
  dotnet --version
}
