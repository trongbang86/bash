alias 'gs=git -c color.status=always status | less -R'
function gd() { git diff --color=always "$@" | less -R; }
function gl() {
    git log --color=always "$@" | less -R
}
alias 'ga=git add'
alias 'gc=git commit -m'
alias 'gp=git push'
function gb() { git branch "$@" | less; }

# This shows all diff pages from the commit value provided
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

# This shows all diff pages from commit #1 to commit #2
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

function git.search() {
    search="$1"
    if [ "$search" == "" ]; then
        read -p "Enter search :" search
    fi
    # clear git.diff file
    # filter git commits with the search term
    # sed to filter the commit numbers
    # for each commmit number, concat the 'git show' to git.diff 
    # less to view the result
    echo '' > /tmp/git.diff | \
        git log -i --grep="$search" | \
        sed -n 's/^commit \([^}]*\)/\1/p' | \
        tail -r | \
        while read x; do git show $x --color=always >> /tmp/git.diff; done && \
            less -R /tmp/git.diff

}
