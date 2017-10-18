alias 'gs=git -c color.status=always status | less -R'
function gd() { git diff --color=always "$@" | less -R; }
alias 'gl=git log --color=always | less -R'
alias 'ga=git add'
alias 'gc=git commit -m'
alias 'gp=git push'
gb() { git branch "$@" | less; }

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
