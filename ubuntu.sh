export PS1LONG="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[36m\][\$(date +%H:%M:%S)]\[\033[m\] \n\$ "
export PS1MEDIUM="\[\033[33;1m\]\W\[\033[36m\][\$(date +%H:%M:%S)]\[\033[m\] \n\$ "
export PS1SHORT="\[\033[33;1m\]\W\[\033[m\] \$ "
export PS1="$PS1MEDIUM"
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias copy='xargs echo -n | xclip -sel clip'
alias 'pwd.copy=pwd | copy'
alias 'xpaste=xclip -out -selection clipboard'
alias 'pbl=xclip -out -selection clipboard | less'
alias 'vim.pb=xclip -out -selection clipboard | vim -'
alias 'ifconfig.addresses=ifconfig |grep inet'

function gp.force() {
    file='/tmp/gp.tmp'
    command="git push 2>&1 | tee $file"
    eval $command
    if grep -q 'has no upstream branch' $file; then
        force=`tail -2 $file | head -1`
        eval $force
    fi
    rm $file
    unset command
    unset force
    unset file
}

# This helps clean the changes for files from clipboard
# by doing git checkout HEAD for those files
function git.checkout.HEAD.from.clipboard {
    xclip -out -selection clipboard | \
        sed 's/^[ ]*//g' | \
        sed 's/modified://g' | \
        sed 's/deleted://g' | \
        while read file; \
        do \
            if [ ! -z "$file" -a "$file" != " " ]; then \
                echo git checkout HEAD -- $file; \
                git checkout HEAD -- $file; \
            fi \
        done;
    git status
}

# This adds all the files provided in clipboard
# These files starts with empty space
function git.add.from.clipboard {
    xclip -out -selection clipboard | \
        sed 's/^[ ]*//g' | \
        sed 's/both modified://g' | \
        sed 's/modified://g' | \
        sed 's/deleted://g' | \
        while read file; \
        do \
            if [ ! -z "$file" -a "$file" != " " ]; then \
                echo Adding $file; \
                git add $file; \
            fi \
        done;
    git status
}

function git.add.from.clipboard.with.edit() {
    pbedit
    git.add.from.clipboard
}

# This helps add files in clipboard copied from
# git status
function git.add.from.status.with.edit() {
    git status | copy
    pbedit
    git.add.from.clipboard
}

# This helps clean the changes for files in 
# git status list
function git.checkout.HEAD.from.status() {
    git status | copy
    pbedit
    git.checkout.HEAD.from.clipboard
}

function git.commit.show.last() {
    last_commit=$(git log | head -1 | awk '{print $2}')
    echo $last_commit | copy
    git show "$last_commit"
    unset last_commit
}


# This helps add files in clipboard with edit feature
function git.add.from.clipboard.with.edit() {
    pbedit
    git.add.from.clipboard
}

# This helps edit the clipboard
function pbedit() {
    file=/tmp/pbedit.tmp
    xclip -out -selection clipboard > $file
    vim $file
    cat $file | copy
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
    echo $command | copy
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
    cat $file | copy
    rm $file
    unset file
    unset command

}

# This copies the last command from history
function lc() {
    last_command=$(history | \
        tail | tac | \
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

# This helps edit the last command from history
function ec() {
    total=1
    file=/tmp/ec.tmp
    if [ -n "$1" ]; then
        total=$1
    fi
    last_command=$(history | \
        tail | tac | \
        cut -d ' ' -f5- | \
        while read c; do \
            if [ "$c" != "lc" ] && [ "$c" != "ec" ] && [ "$c" != "hist" ]; then \
                # if it's not lc command
                # then use it
                echo "$c"; \
            fi \
        done | \
        head -$total)
    echo "$last_command" > $file
    vim $file
    cat $file | copy
    rm $file
    unset file
    unset total
    unset last_command
}

# This helps search and edit commands from history
function ec.search() {
    file=/tmp/ec.tmp
    if [ -n "$1" ]; then
        query=$1
    else
        read -p 'Enter search:' query
    fi
    commands=$(history | \
        tail -r | \
        tail +2 | \
        cut -d ' ' -f5- | \
        while read c; do \
            c=$(echo $c | grep -i "$query")
            if [ "$c" != "" ]; then \
                echo "$c"; \
            fi \
        done)
    echo "$commands" > $file
    vim $file
    cat $file | copy
    rm $file
    unset file
    unset query
    unset commands
}

# This is to show diff for the git commits that
# satisfy the search requirements
# usage: git.search 'a message' 'author'
function git.search() {
    if [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        echo "Usage: git.search 'a message' 'author'"
        return
    fi
    search="$1"
    author="$2"
    # clear git.diff file
    # filter git commits with the search term
    # sed to filter the commit numbers
    # for each commmit number, concat the 'git show' to git.diff 
    # less to view the result
    echo '' > /tmp/git.diff | \
        git log -i --grep="$search" --author="$author" | \
        sed -n 's/^commit \([^}]*\)/\1/p' | \
        tail | tac | \
        while read x; do git show $x --color=always >> /tmp/git.diff; done && \
            less -R /tmp/git.diff
    unset search
    unset author

}
