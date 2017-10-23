
alias 'cd.=cd ~'
alias 'cd.bash=cd ~/bash'
alias 'cl=clear'
alias 'll=ls -lat'
alias 'vbp=vim ~/.bash_profile'
alias 'vbpa=vim ~/.bash_profile_after'
alias 'vteamocil=vim ~/.teamocil'
function abp() {
    PS1_TMP=$PS1
    source ~/.bash_profile
    export PS1=$PS1_TMP
    unset PS1_TMP
}
alias 'v.=vim .'
alias 'vbash=vim ~/bash'
alias 'find.no.git=find . ! \( -path "*/.git*" -prune \)'
alias 'find.smart=find . ! \( -path "*/.git*" -prune \) -and ! \( -path "*/.idea*" \) -and ! \( -path "*/build/*" \)'
alias 't2f=tee /tmp/t2f.txt'
alias 'hist=history | less'
alias ps1.long="export "PS1=\$PS1LONG""
alias ps1.short="export "PS1=\$PS1SHORT""

alias "t2f=tee $T2F"
alias "lt2f= less $T2F"

t2f.latest() {
    i=$(wc -l $T2F | awk '{print $1}')
    echo 'Press Enter to continue...'; read DUMMY
    less +$i $T2F
}


less.latest() {
    [ "$1" == "" ] && echo Please specify file... && return
    [ ! -f "$1" ] && echo File does not exist... && return
    i=$(wc -l "$1" | awk '{print $1}')
    echo 'Press Enter to continue...'; read DUMMY
    less +$i "$1"
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

source ~/bash/git.sh
