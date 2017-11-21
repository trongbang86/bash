# This starts ssh agent to keep secret key/passphrase
function ssh.start.agent() {
    #exec ssh-agent bash
    eval `ssh-agent` > /dev/null
    set_ssh_agent_socket # ssh-find-agent.sh
    ssh-add
}

# This concatenates files to create .bashrc
# and sources it in the remote server
# Ex: ssh.custom user@server removeFlag ~/.bash1 ~/.bash2
function ssh.custom() {
    # this is a temporary file as the concatenation result
    file=/tmp/.bashrc_temp
    # this is the remote file in server
    file_remote=/tmp/.bashrc_temp
    #clear the file
    [[ -f "$file" ]] && file="$file-$(date +%H-%M-%S)"
    echo "" > $file
    args=( "$@" )
    server="${args[0]}"
    removeCommand="rm $file_remote"
    removeFlag="${args[1]}"
    if [ "$removeFlag" == "false" ]; then
        removeCommand="echo '' > /dev/null "
    fi

    #loop through the files and concatenate them
    #except the first argument which is the server
    for i in "${!args[@]}"; do 
        if [ "$i" -gt 1 ]; then
            if [[ -f "${args[$i]}" ]]; then
                cat "${args[$i]}" >> $file
            fi
        fi
    done
    ssh $server "cat > $file_remote" < $file
    rm $file
    ssh -t $server "bash --rcfile $file_remote && $removeCommand"
    unset args
    unset file
    unset file_remote
    unset removeCommand
    unset removeFlag
    unset server
}

source ~/bash/ssh-find-agent.sh
