export PS1LONG="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[36m\][$(date +%H:%M:%S)]\[\033[m\] \$ "
export PS1SHORT="\[\033[33;1m\]\W\[\033[m\] \$ "
export PS1="$PS1LONG"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias 'pwd.copy=pwd | pbcopy'
alias 'pbl=pbpaste | less'

# This adds all the files provided in clipboard
# These files starts with empty space
function git.add.from.clipboard {
    pbpaste | \
        sed 's/^[ ]*//g' | \
        while read file; \
        do \
            if [ ! -z "$file" -a "$file" != " " ]; then \
                echo Adding $file; \
                git add $file; \
            fi \
        done;
}

function hist.copy() {
    if [ "$1" == "" ]; then
        read -p 'Enter history number:' history_num
    else
        history_num=$1
    fi
    command=`history | grep "^[ ]*$history_num" | cut -d ' ' -f5-`
    echo $command
    echo $command | pbcopy
    unset command
    unset history_num
}
