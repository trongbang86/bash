function tools.display.big() {
  local id
  id=$(displayplacer list | grep -B3 "built in" | grep "Persistent screen id" | awk '{print $4}')
  if [ -z "$id" ]; then
    echo "Built-in display not found."
    return 1
  fi
  displayplacer "id:$id res:1800x1169 hz:120 color_depth:8 enabled:true scaling:on"
}

function tools.display.small() {
  local id
  id=$(displayplacer list | grep -B3 "built in" | grep "Persistent screen id" | awk '{print $4}')
  if [ -z "$id" ]; then
    echo "Built-in display not found."
    return 1
  fi
  displayplacer "id:$id res:1147x745 hz:120 color_depth:8 enabled:true scaling:on"
}
