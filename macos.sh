export PS1LONG="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[36m\][\$(date +%H:%M:%S)]\[\033[m\] \$ "
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
        sed 's/modified://g' | \
        while read file; \
        do \
            if [ ! -z "$file" -a "$file" != " " ]; then \
                echo Adding $file; \
                git add $file; \
            fi \
        done;
    git status
}

# This helps add files in clipboard copied from
# git status
function git.add.from.clipboard.with.edit.from.status() {
    git status | pbcopy
    pbedit
    git.add.from.clipboard
}

# This helps add files in clipboard with edit feature
function git.add.from.clipboard.with.edit() {
    pbedit
    git.add.from.clipboard
}

# This helps edit the clipboard
function pbedit() {
    file=/tmp/pbedit.tmp
    pbpaste > $file
    vim $file
    cat $file | pbcopy
    unset file
}

# This helps copy a command from history
# and copies it to clipboard
function h.c() {
    if [ "$1" == "" ]; then
        read -p 'Enter history number:' history_num
    else
        history_num=$1
    fi
    command=`history | grep "^[ ]*$history_num" | cut -d ' ' -f5-`
    echo $command | pbcopy
    echo $command
    unset command
    unset history_num
}

# This helps edit a command from history
# and copies it to clipboard
function h.e() {
    if [ "$1" == "" ]; then
        read -p 'Enter history number:' history_num
    else
        history_num=$1
    fi
    command=`history | grep "^[ ]*$history_num" | cut -d ' ' -f5-`
    file=/tmp/ec.tmp
    echo $command > $file
    vim $file
    cat $file | pbcopy
    rm $file
    unset file
    unset command

}

# This helps edit the last command from history
function ec() {
    file=/tmp/ec.tmp
    last_command=$(history | \
        tail -r | \
        cut -d ' ' -f5- | \
        while read c; do \
            if [ "$c" != "lc" ] && [ "$c" != "ec" ] && [ "$c" != "hist" ]; then \
                # if it's not lc command
                # then use it
                echo $c; \
            fi \
        done | \
        head -1)
    echo $last_command > $file
    vim $file
    cat $file | pbcopy
    rm $file
    unset file
    unset last_command
}

