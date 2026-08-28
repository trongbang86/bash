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

_ssh_agent_file="${BASH_DIR:-$HOME/bash}/ssh-find-agent.sh"
[ -f "$_ssh_agent_file" ] && . "$_ssh_agent_file"
unset _ssh_agent_file

ssh.generate.alias() {
    [ "$((${#SSH_SERVERS[@]} % 9))" -eq 0 ] ||
        { echo 'SSH_SERVERS must contain groups of nine fields.' >&2; return 2; }
    local i group server user pass_key jump_user jump_host jump_user2 jump_host2 desc command_name
    local password_command ssh_command
    for ((i=0; i<${#SSH_SERVERS[@]}; i+=9)); do
        group="${SSH_SERVERS[i]}"; server="${SSH_SERVERS[i+1]}"; user="${SSH_SERVERS[i+2]}"
        pass_key="${SSH_SERVERS[i+3]}"; jump_user="${SSH_SERVERS[i+4]}"; jump_host="${SSH_SERVERS[i+5]}"
        jump_user2="${SSH_SERVERS[i+6]}"; jump_host2="${SSH_SERVERS[i+7]}"; desc="${SSH_SERVERS[i+8]}"
        command_name="ssh.${group}.${desc//[^[:alnum:]_]/_}"
        if [[ ! "$command_name" =~ ^[[:alnum:]_.]+$ ]]; then
            echo "Cannot create SSH alias with unsafe name: $command_name" >&2
            return 2
        fi
        password_command=':'
        if [ -n "$pass_key" ]; then
            if declare -F tools.password >/dev/null 2>&1; then
                printf -v password_command 'tools.password %q' "$pass_key"
            else
                echo "Warning: $command_name has a pass_key but tools.password is not defined; SSH will prompt normally." >&2
            fi
        fi
        if [ -n "$jump_host2" ]; then
            printf -v ssh_command 'ssh -J %q %q' "$jump_user@$jump_host,$jump_user2@$jump_host2" "$user@$server"
        elif [ -n "$jump_host" ]; then
            printf -v ssh_command 'ssh -J %q %q' "$jump_user@$jump_host" "$user@$server"
        else
            printf -v ssh_command 'ssh %q' "$user@$server"
        fi
        eval "$command_name() { $password_command; $ssh_command; }"
    done
}
