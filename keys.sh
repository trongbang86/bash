export IGNOREEOF=4   # Shell only exits after the 4th consecutive Ctrl-d

alias 'cd.=cd ~'
alias 'cd.bash=cd ~/bash'
alias 'cd.custom.bash=cd ~/custom_bash/'
alias 'cl=clear'
alias 'll=CLICOLOR_FORCE=1 ls -at'
alias 'll.10=ll | head -10'
alias 'll.grep=ll | grep -i'
alias 'lll=ll | less -R'
alias 'files.biggest=du -a . | sort -n -r | head -n 10'
alias 'vbp=vim ~/.bash_profile'
alias "vbpa=vim $BASH_PROFILE_AFTER"
alias "vbpb=vim $BASH_PROFILE_BEFORE"
alias 'vteamocil=vim ~/.teamocil'
alias 'v.=vim .'
alias 'vbash=vim ~/bash'
alias 'vcbash= vim ~/custom_bash'
tm.abp() { . "${BASH_DIR:-$HOME/bash}/tmux.sh"; }
alias 'find.no.git=find . ! \( -path "*/.git*" -prune \)'
alias 'find.smart=find . ! \( -path "*/.git*" -prune \) -and ! \( -path "*/node_modules*" -prune \) -and ! \( -path "*/bower_components*" -prune \) -and ! \( -path "*/.idea*" \) -and ! \( -path "*/build/*" \)'
alias 'hist=history | less'

# This searches and replaces content in the current folder
function grep.replace() {
  local file
  while IFS= read -r file; do bsed_in_place "s/$1/$2/g" "$file"; done < <(grep -RIl "$1" .)
}

# This adds more line breaks
function awk.more.lines() {
    awk '{printf("%s\n\n\n\n",$0)}'
}

alias ps1.long="export "PS1=\$PS1LONG""
alias ps1.medium="export "PS1=\$PS1MEDIUM""
alias ps1.short="export "PS1=\$PS1SHORT""

function ps1 {
    if [ "$PS1" == "$PS1LONG" ]; then
        ps1.short
    else
        ps1.long
    fi
}

alias "t2f=tee $T2F"
alias "lt2f= less -R $T2F"
alias "vt2f= vim $T2F"

t2f.latest() {
    cb_file=/tmp/cb.t2f.latest.txt
    cb_i=$(wc -l $T2F | awk '{print $1}')
    echo 'Press Enter to continue...'; read DUMMY
    tail -$cb_i $T2F > $cb_file
    less -R $cb_file
    rm $cb_file
    unset cb_file
    unset cb_i
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

function ps.grep() {
    # add more lines between new lines
    # split -D with new lines for java
    ps aux | \
        grep $1 |  \
        sed $'s/$/\\\n\\\n\\\n\\\n\\\n/g' | \
        sed $'s/-D/\\\n-D/g' | \
        less
}

# Get the name of the corresponding script
# for the current folder
function scripts.name() {
    echo /tmp/scripts_$(pwd | sed 's/\//_/g' | sed 's/:/_/g').sh
}

# Creating on-the-fly script to edit
function scripts.edit() {
    vim $(scripts.name)
}

# Source the on-the-fly script
function scripts.source() {
    source $(scripts.name)
}

# Run the on-the-fly script
function scripts.run() {
    . $(scripts.name)
}

# This replaces a string with another string
# in the current folder
function grep.replace () 
{ 
  local file
  while IFS= read -r file; do bsed_in_place "s/$1/$2/g" "$file"; done < <(grep -RIl "$1" .)
}

# Cross-platform clipboard helpers. platform.sh supplies bcopy/bpaste.
pwd.copy() { pwd | bcopy; }
pbl() { bpaste | less; }
vim.pb() { bpaste | vim -; }
pbedit() {
    local file="${TMPDIR:-/tmp}/pbedit.$$"
    bpaste > "$file" || return
    vim "$file"
    bcopy < "$file"
    rm -f "$file"
}
git.add.from.clipboard() {
    bpaste | sed -e 's/^[[:space:]]*//' -e 's/^both modified://' -e 's/^modified://' -e 's/^deleted://' |
        while IFS= read -r file; do [ -n "$file" ] && git add -- "$file"; done
    git status
}
git.checkout.HEAD.from.clipboard() {
    bpaste | sed -e 's/^[[:space:]]*//' -e 's/^modified://' -e 's/^deleted://' |
        while IFS= read -r file; do [ -n "$file" ] && git checkout HEAD -- "$file"; done
    git status
}
