function gs() {
    git -c color.status=always status | less -R
    git status | head -1 | cut -d ' ' -f 3
}
function gd() { git diff --color=always "$@" | less -R; }
function gl() {
    git log --color=always "$@" | less -R
}

function ga() {
    if [ -z "$1" ]; then 
        git add .
    else
        git add "$@"
    fi
}

alias 'gc=git commit -m'
alias 'gsl=git stash list'
alias 'git.conflicts=git diff --name-only --diff-filter=U | less'

# git push with checking for master branch
function gp() {
    # checking if it's on master branch
    CHECK=$(git status | head -1 | grep 'On branch master')
    if [ -n "$CHECK" ]; then
        read -p 'Type "no" to stop commiting to master branch:' CONFIRMATION
        if [ "$CONFIRMATION" == "no" ]; then
            echo 'You are safe. Nothing was deleted.'
        else
            git push
        fi
    else
        git push
    fi
    unset CHECK
}

function gb() { git branch "$@" | less; }

# view and delete branches
function gb.delete() {
    FILE=/tmp/git.branch
    if [ "$1" == "force" ]; then
        MODE='-D'
    else
        MODE='-d'
    fi
    git branch | grep -v '\*' > $FILE
    vim $FILE
    echo You are about to delete the following branches
    echo -------------------------
    cat $FILE
    echo -------------------------
    read -p 'Type "yes" to confirm to delete branches: ' CONFIRMATION
    if [ "$CONFIRMATION" == "yes" ]; then
        cat $FILE | xargs git branch $MODE | less
        rm $FILE
    else
        echo 'You are safe. Nothing was deleted.'
    fi
    unset FILE
    unset CONFIRMATION
    unset MODE
}

# view and delete branches with force
function gb.delete.force() {
    gb.delete 'force'
}

# This shows diff for one particular commit
git.commit.show() {
    git.from.commit.to.commit $1 $1
}



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
    unset commit
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
    unset commit1
    unset commit2
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
        tail -r | \
        while read x; do git show $x --color=always >> /tmp/git.diff; done && \
            less -R /tmp/git.diff
    unset search
    unset author

}

function git.stash.all() {
    git stash save -u "$1"
}
