
alias 'cd.=cd ~'
alias 'cl=clear'
alias 'vbp=vim ~/.bash_profile'
alias 'vbpa=vim ~/.bash_profile_after'
alias 'vteamocil=vim ~/.teamocil'
alias 'abp=source ~/.bash_profile'
alias 'v.=vim .'
alias 'vbash=vim ~/bash'
alias 'find.no.git=find . ! \( -path "*/.git*" -prune \)'
alias 'find.smart=find . ! \( -path "*/.git*" -prune \) -and ! \( -path "*/.idea*" \) -and ! \( -path "*/build/*" \)'
alias 't2f=tee /tmp/t2f.txt'
alias 'gs=git -c color.status=always status | less -R'
gd() { git diff --color=always "$@" | less -R; }
alias 'gl=git log --color=always | less -R'
alias 'ga=git add'
alias 'gc=git commit -m'
alias 'gp=git push'
gb() { git branch "$@" | less; }
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

git.from.commit() {
    if [ "$1" == "" ]
    then
        read -p "Enter the first commit: " commit
    else
        commit=$1
    fi

    # clear /tmp/git.diff file
    # filter commit numers from git log
    # use awk to print until it reaches the specific commit number
    # reverse the order
    # for each commit number, write `git show` to /tmp/git.diff file
    # use less to view the result
    echo '' > /tmp/git.diff | \
        git log | \
        sed -n 's/^commit \([^}]*\)/\1/p' | \
        awk "BEGIN{a=0}{if(a==0){print}; if(/^$commit/){a=1}}" | \
        tail -r | \
        while read x; do git show $x --color=always >> /tmp/git.diff; done && \
            less -R /tmp/git.diff
}

git.from.commit.to.commit() {
    if [ "$1" == "" ]
    then
        read -p "Enter the first commit: " commit1
    else
        commit1=$1
    fi


    if [ "$2" == "" ]
    then
        read -p "Enter the last commit: " commit2
    else
        commit2=$2
    fi

    # clear /tmp/git.diff file
    # filter commit numers from git log
    # use awk to print until it reaches the specific commit number
    # reverse the order
    # for each commit number, write `git show` to /tmp/git.diff file
    # use less to view the result
    echo '' > /tmp/git.diff | \
        git log | \
        sed -n 's/^commit \([^}]*\)/\1/p' | \
        awk "BEGIN{a=0}{if(/^$commit2/){a=1} if(a==1){print} if(/^$commit1/){a=0}}" | \
        tail -r | \
        while read x; do git show $x --color=always >> /tmp/git.diff; done && \
            less -R /tmp/git.diff
}
