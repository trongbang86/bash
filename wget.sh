function wget.download.a.webpage() {
  local page=$1
  if [ -z "$page" ]; then
    printf "Enter webpage:"
    read page
  fi
  wget -p -k $page
}
