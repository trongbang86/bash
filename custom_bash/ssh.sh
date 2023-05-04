#name,target,user_target,password_target,user_jump,jump_host,user_jump2,jump_host2,desc
SSH_SERVERS=(
'service.nft' 'server.me' 'bang' 'onprem' 'bang2' 'server.jump' '' '' 'desc'
)


function ssh.password.onprem1() {
  tools.password onprem1
}

function ssh.password.onprem() {
  tools.password onprem
}

function ssh.generate.alias() {
	for i in "${!SSH_SERVERS[@]}"; do 
    if [[ "$(($i%9))" -eq 0 ]]; then
      TMP_GROUP=${SSH_SERVERS[$i]}
      TMP_SERVER=${SSH_SERVERS[$i+1]}
      TMP_USER=${SSH_SERVERS[$i+2]}
      TMP_PASS=${SSH_SERVERS[$i+3]}
      TMP_USER_JUMP=${SSH_SERVERS[$i+4]}
      TMP_JUMP=${SSH_SERVERS[$i+5]}
      TMP_USER_JUMP2=${SSH_SERVERS[$i+6]}
      TMP_JUMP2=${SSH_SERVERS[$i+7]}
      TMP_DESC=${SSH_SERVERS[$i+8]}
      TMP_SSH_NOJB="tools.password $TMP_PASS; ssh $TMP_USER@$TMP_SERVER; "
      TMP_SCP_NOJB="cd.downloads; tools.password $TMP_PASS; scp $TMP_USER@$TMP_SERVER:/home/$TMP_USER/tmp/scp \$1; "
      TMP_SCP_TO_NOJB="tools.password $TMP_PASS; scp \$1 $TMP_USER@$TMP_SERVER:/home/$TMP_USER/tmp/scp; "
      TMP_SSH_JB="tools.password $TMP_PASS; ssh -J $TMP_USER_JUMP@$TMP_JUMP $TMP_USER@$TMP_SERVER; "
      TMP_SCP_JB="cd.downloads; tools.password $TMP_PASS; scp -oProxyJump=$TMP_USER_JUMP@$TMP_JUMP $TMP_USER@$TMP_SERVER:/home/bang/tmp/scp \$1; "
      TMP_SCP_TO_JB="tools.password $TMP_PASS; scp -oProxyJump=$TMP_USER_JUMP@$TMP_JUMP \$1 $TMP_USER@$TMP_SERVER:/home/bang/tmp/scp ; "
      TMP_SSH_JB2="tools.password $TMP_PASS; ssh -J $TMP_USER_JUMP@$TMP_JUMP,$TMP_USER_JUMP2@$TMP_JUMP2 $TMP_USER@$TMP_SERVER; "
      TMP_SCP_JB2="cd.downloads; tools.password $TMP_PASS; scp -oProxyJump=$TMP_USER_JUMP@$TMP_JUMP,$TMP_USER_JUMP2@$TMP_JUMP2 $TMP_USER@$TMP_SERVER:/home/bang/tmp/scp \$1; "
      TMP_SCP_TO_JB2="tools.password $TMP_PASS; scp -oProxyJump=$TMP_USER_JUMP@$TMP_JUMP,$TMP_USER_JUMP2@$TMP_JUMP2 \$1 $TMP_USER@$TMP_SERVER:/home/bang/tmp/scp ; "
      if [ -z "$TMP_JUMP" ]; then
        TMP_FUNC=" function ssh.$TMP_GROUP.$i.$TMP_SERVER.$TMP_DESC() { $TMP_SSH_NOJB }"
      else
        TMP_FUNC=" function ssh.$TMP_GROUP.$i.$TMP_SERVER.$TMP_DESC() { $TMP_SSH_JB }"
      fi
      if [ ! -z "$TMP_JUMP2" ]; then
        TMP_FUNC=" function ssh.$TMP_GROUP.$i.$TMP_SERVER.$TMP_DESC() { $TMP_SSH_JB2 }"
      fi
      eval $TMP_FUNC
      if [ -z "$TMP_JUMP" ]; then
        TMP_FUNC=" function ssh.$TMP_GROUP.$TMP_SERVER.$i.$TMP_DESC() { $TMP_SSH_NOJB }"
      else
        TMP_FUNC=" function ssh.$TMP_GROUP.$TMP_SERVER.$i.$TMP_DESC() { $TMP_SSH_JB }"
      fi
      if [ ! -z "$TMP_JUMP2" ]; then
        TMP_FUNC=" function ssh.$TMP_GROUP.$TMP_SERVER.$i.$TMP_DESC() { $TMP_SSH_JB2 }"
      fi
      eval $TMP_FUNC
      if [ -z "$TMP_JUMP" ]; then
        TMP_FUNC=" function ssh.hosts.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SSH_NOJB }"
      else
        TMP_FUNC=" function ssh.hosts.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SSH_JB }"
      fi
      if [ ! -z "$TMP_JUMP2" ]; then
        TMP_FUNC=" function ssh.hosts.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SSH_JB2 }"
      fi
      eval $TMP_FUNC
      if [ -z "$TMP_JUMP" ]; then
        TMP_FUNC=" function scp.hosts.from.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SCP_NOJB $1 }"
      else
        TMP_FUNC=" function scp.hosts.from.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SCP_JB $1 }"
      fi
      if [ ! -z "$TMP_JUMP2" ]; then
        TMP_FUNC=" function scp.hosts.from.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SCP_JB2 $1 }"
      fi
      eval $TMP_FUNC
      if [ -z "$TMP_JUMP" ]; then
        TMP_FUNC=" function scp.hosts.to.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SCP_TO_NOJB $1 }"
      else
        TMP_FUNC=" function scp.hosts.to.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SCP_TO_JB $1 }"
      fi
      if [ ! -z "$TMP_JUMP2" ]; then
        TMP_FUNC=" function scp.hosts.to.$TMP_SERVER.$i.$TMP_GROUP.$TMP_DESC() { $TMP_SCP_TO_JB2 $1 }"
      fi
      eval $TMP_FUNC
    fi
	done
  unset TMP_SSH_NOJB
  unset TMP_SSH_JB
  unset TMP_GROUP
  unset TMP_SERVER
  unset TMP_USER
  unset TMP_PASS
  unset TMP_USER_JUMP
  unset TMP_DESC
  unset TMP_JUMP
}

ssh.generate.alias
