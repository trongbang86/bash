export IGNOREEOF=4   # Shell only exists after the 4th consecutive Ctrl-d

alias 'cd.=cd ~'
alias 'cd.bash=cd ~/bash'
alias 'cd.custom.bash=cd ~/custom_bash/'
alias 'cl=clear'
alias 'll=CLICOLOR_FORCE=1 ls -at'
alias 'll.10=ll | head -10'
alias 'll.grep=ll | grep -i'
alias 'lll=ll | less -R'
alias 'vbp=vim ~/.bash_profile'
alias "vbpa=vim $BASH_PROFILE_AFTER"
alias "vbpb=vim $BASH_PROFILE_BEFORE"
alias 'vteamocil=vim ~/.teamocil'
alias 'v.=vim .'
alias 'vbash=vim ~/bash'
alias 'vcbash= vim ~/custom_bash'
alias 'find.no.git=find . ! \( -path "*/.git*" -prune \)'
alias 'find.smart=find . ! \( -path "*/.git*" -prune \) -and ! \( -path "*/node_modules*" -prune \) -and ! \( -path "*/bower_components*" -prune \) -and ! \( -path "*/.idea*" \) -and ! \( -path "*/build/*" \)'
alias 'hist=history | less'


# Change ctrl-k with ctrl-r
# shortcut to remove all characters to the end
bind '"\C-r":"\C-k"'

# This adds more line breaks
function awk.more.lines() {
    awk '{printf("%s\n\n\n\n",$0)}'
}

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
