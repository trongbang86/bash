export GOPROXY=https://artifactory.internal.cba/api/go/gocenter-proxy
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

function go.dlv.with.vscode() {
  local vscode_dir=".vscode"
  local launch_file="$vscode_dir/launch.json"

  if [ -n "$1" ]; then
    test_folder="$1"
  else
    read -p "Enter the folder containing the test file: " test_folder
  fi

  # Create .vscode directory if it doesn't exist
  if [ ! -d "$vscode_dir" ]; then
    mkdir "$vscode_dir"
  fi

  local choice="N"

  if [ -f "$launch_file" ]; then
    read -p "launch.json already exists. Do you want to overwrite it? (y/n): " choice

  else
    choice="Y"
  fi

  if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    echo "Skipping the creation of launch.json"
  else

    # Create or overwrite launch.json with the required configuration
    cat > "$launch_file" <<EOL
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Attach to Delve",
      "type": "go",
      "request": "attach",
      "mode": "remote",
      "remotePath": "\${workspaceFolder}",
      "port": 2345,
      "host": "127.0.0.1",
      "apiVersion": 2
    }
  ]
}
EOL

    echo "Configured $launch_file"
  fi

  # Run the dlv command
  dlv test --headless --listen=:2345 --api-version=2 --log "$test_folder"
}
