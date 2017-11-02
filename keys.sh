
alias 'cd.=cd ~'
alias 'cd.bash=cd ~/bash'
alias 'cd.custom.bash=cd ~/custom_bash/'
alias 'cl=clear'
alias 'll=CLICOLOR_FORCE=1 ls -lat'
alias 'lll=ll | less -R'
alias 'vbp=vim ~/.bash_profile'
alias "vbpa=vim $BASH_PROFILE_AFTER"
alias "vbpb=vim $BASH_PROFILE_BEFORE"
alias 'vteamocil=vim ~/.teamocil'
function abp() {
    PS1_TMP=$PS1
    source ~/.bash_profile
    export PS1=$PS1_TMP
    unset PS1_TMP
}
alias 'v.=vim .'
alias 'vbash=vim ~/bash'
alias 'vcbash= vim ~/custom_bash'
alias 'find.no.git=find . ! \( -path "*/.git*" -prune \)'
alias 'find.smart=find . ! \( -path "*/.git*" -prune \) -and ! \( -path "*/.idea*" \) -and ! \( -path "*/build/*" \)'
alias 't2f=tee /tmp/t2f.txt'
alias 'hist=history | less'
alias ps1.long="export "PS1=\$PS1LONG""
alias ps1.short="export "PS1=\$PS1SHORT""

alias "t2f=tee $T2F"
alias "lt2f= less -R $T2F"

t2f.latest() {
    i=$(wc -l $T2F | awk '{print $1}')
    echo 'Press Enter to continue...'; read DUMMY
    less -R +$i $T2F
}


less.latest() {
    [ "$1" == "" ] && echo Please specify file... && return
    [ ! -f "$1" ] && echo File does not exist... && return
    i=$(wc -l "$1" | awk '{print $1}')
    echo The last line number at this moment is $i
    echo 'Press Enter to continue...'; read DUMMY
    less -R +$i "$1"
    unset i
}

function openssl.getCert() {
    read -p "Enter server: " server
    read -p "Enter port: " port
    read -p "Output .cer file: " file
    openssl s_client -showcerts -connect $server:$port -servername $server < /dev/null 2> /dev/null | openssl x509 -outform PEM > $file
    unset server
    unset port
    unset file
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

#This simulates one line command to download a file
#from server
function sftp.get() {
    args=( "$@" )
    server="${args[0]}"
    file="${args[1]}"
    sftp $server <<< "get $file"
    #sftp $server
    unset server
    unset file
}

#This simulates one line command to upload a file
#to server
function sftp.put() {
    args=( "$@" )
    server="${args[0]}"
    file="${args[1]}"
    folder="${args[2]}"
    sftp $server:$remote_folder <<< "put $file"
    #sftp $server
    unset remote_folder
    unset server
    unset file
}
