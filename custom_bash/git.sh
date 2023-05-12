#https://www.macinstruct.com/tutorials/how-to-enable-git-tab-autocomplete-on-your-mac/
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

function gp.force() {
  TMP_command=`gp 2>&1 | tail -5 | sed -e 's/^[[:space:]]*//' | head -1`
  eval $TMP_command
  unset TMP_command
}

function git.rebase.from.upstream.develop() {
  git rebase upstream/develop
}

function git.pr() {
  TMP_PR=$1
  TMP_BRANCHNAME=pr-$TMP_PR

  if [[ "$TMP_PR" != "" ]]; then
    echo -n "This will force deletion of branch $TMP_BRANCHNAME [y/n/enter=y]? "
    read TMP_ANSWER
    if [[ "$TMP_ANSWER" != "n" ]]; then
      git checkout master || git checkout develop
      git branch -D $TMP_BRANCHNAME
      git fetch origin pull/$TMP_PR/head:$TMP_BRANCHNAME
      git checkout $TMP_BRANCHNAME
      ga && gc "DON'T COMMIT"
    else
      echo You cancelled
    fi
  else
    echo Please enter PR number
  fi
  unset TMP_PR
  unset TMP_BRANCHNAME
  unset TMP_ANSWER
}

function git.add.from.status() {
  TMP_STATUS='/tmp/tmp.git.status'
  TMP_STATUS1="$TMP_STATUS.1"
  rm $TMP_STATUS
  rm $TMP_STATUS1
  git status 2>&1 >> $TMP_STATUS
  tail +4 $TMP_STATUS > $TMP_STATUS1
  vim $TMP_STATUS1
  cat $TMP_STATUS1 | awk -F ':' '{if($2 !="") print $2; else print $1;}' > $TMP_STATUS
  cat $TMP_STATUS | sed '/^$/d' > $TMP_STATUS1
  cat $TMP_STATUS1 | while read TMP_LINE
  do
    git add $TMP_LINE
  done

  rm $TMP_STATUS
  rm $TMP_STATUS1
  unset TMP_STATUS
  unset TMP_STATUS1
  unset TMP_LINE
}

function git.checkout.pull.come.back() {
  TMP_CURR=`git status | head -1 | cut -d ' ' -f 3`
  git checkout $1
  git pull
  git checkout $TMP_CURR 
  unset TMP_CURR 
}

function git.diff.generate.revert.changes() {
  TMP_FILE=/tmp/git.revert.commit
  git diff HEAD HEAD^ > $TMP_FILE
  git apply $TMP_FILE
  unset TMP_FILE
}

function git.cb.commit() {
  TMP_CB=/Users/bang/custom_bash
  git --git-dir=$TMP_CB/.git/ --work-tree=$TMP_CB/ add .
  git --git-dir=$TMP_CB/.git/ --work-tree=$TMP_CB/ commit -m 'new commit'
  unset TMP_CB
}

function git.docs.commit() {
  git --git-dir=$DOCS/.git/ --work-tree=$DOCS/ add .
  git --git-dir=$DOCS/.git/ --work-tree=$DOCS/ commit -m 'new commit'
}

function git.log.a.file() {
  git log --all --full-history -- "**/$1"
}
