
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
alias 'hist=history | less'

# This copies the last command from history
function lc() {
    last_command=$(history | \
        tail -r | \
        cut -d ' ' -f5- | \
        while read c; do \
            if [ "$c" != "lc" ]; then \
                # if it's not lc command
                # then use it
                echo $c; \
            fi \
        done | \
        head -1)
    eval "$last_command"
    unset last_command
}

alias ps1.long="export "PS1=\$PS1LONG""
alias ps1.short="export "PS1=\$PS1SHORT""

alias "t2f=tee $T2F"
alias "lt2f= less -R $T2F"
alias "vt2f= vim $T2F"

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

