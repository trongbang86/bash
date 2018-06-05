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
    #clear the file before concatenation
    [[ -f "$file" ]] && file="$file-$(date +%H-%M-%S)"
    echo "" > $file
    args=( "$@" )
    server="${args[0]}"
    # generating the removeCommand of the file
    # based on the flag provided to this function
    removeCommand="rm $file_remote"
    removeFlag="${args[1]}"
    if [ "$removeFlag" == "false" ]; then
        removeCommand="echo '' > /dev/null "
    fi

    #loop through the files and concatenate them
    #except the first argument which is the server
    for i in "${!args[@]}"; do 
        if [ "$i" -gt 1 ]; then
            is.debug && echo "Concatenating: ${args[$i]}" 
            if [[ -f "${args[$i]}" ]]; then
                cat "${args[$i]}" >> $file
            elif [[ -d "${args[$i]}" ]]; then
                sub_server_files=$(find ${args[$i]} -iname '*.sh' -type f)
                # looping through the folder for *.sh file
                for sub_server_file in $sub_server_files; do
                    is.debug && echo "Concatenating sub file: $sub_server_file"
                    cat "$sub_server_file" >> $file
                done
            fi

        fi
    done
    ssh $server "cat > $file_remote" < $file
    rm $file
    ssh -t $server "bash --rcfile $file_remote && $removeCommand"
    unset sub_server_file
    unset args
    unset file
    unset file_remote
    unset removeCommand
    unset removeFlag
    unset server
}

[ -f ~/bash/ssh-find-agent.sh ] && source ~/bash/ssh-find-agent.sh
