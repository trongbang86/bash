# Needs one argument
# ssh.password onprem
function tools.password() {
  TMP_PWD=`pwd`
  cd.tools
  cd tools.eh
  python3.venv 1>/dev/null
  python3 tasks_password.py $1 | pbcopy
  deactivate
  cd $TMP_PWD
  unset TMP_PWD
}
