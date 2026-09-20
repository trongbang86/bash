alias k='kubectl'
alias kns='kubectl config set-context --current --namespace'
alias kgp='kubectl get pods'
alias kgpa='kubectl get pods -A'
alias kgn='kubectl get nodes -o wide'

function k8s.load() {
  # Load one or more images from Docker Desktop into all kind nodes.
  # Usage: k8s.load <image> [<image2> ...]
  if [[ $# -eq 0 ]]; then
    echo "Usage: k8s.load <image> [<image2> ...]"
    return 1
  fi
  local cluster="${KIND_CLUSTER:-kind}"
  local nodes=("${cluster}-control-plane" "${cluster}-worker" "${cluster}-worker2" "${cluster}-worker3")
  for image in "$@"; do
    echo "Loading ${image}..."
    for node in "${nodes[@]}"; do
      docker image save "${image}" | docker exec -i "${node}" \
        ctr --namespace=k8s.io images import --snapshotter=overlayfs -
    done
    echo "  ${image} loaded into all nodes"
  done
}
