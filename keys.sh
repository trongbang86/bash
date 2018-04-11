
alias 'cd.=cd ~'
alias 'cd.bash=cd ~/bash'
alias 'cd.custom.bash=cd ~/custom_bash/'
alias 'cl=clear'
alias 'll=CLICOLOR_FORCE=1 ls -lat'
alias 'll.10=CLICOLOR_FORCE=1 ls -lat | head -10'
alias 'lll=ll | less -R'
alias 'vbp=vim ~/.bash_profile'
alias "vbpa=vim $BASH_PROFILE_AFTER"
alias "vbpb=vim $BASH_PROFILE_BEFORE"
alias 'vteamocil=vim ~/.teamocil'
function abp() {
    PS1_TMP=$PS1
    source ~/.bash_profile
    export PS1=$PS1_TMP
    unset PS1_TMP
}
alias 'v.=vim .'
alias 'vbash=vim ~/bash'
alias 'vcbash= vim ~/custom_bash'
alias 'find.no.git=find . ! \( -path "*/.git*" -prune \)'
alias 'find.smart=find . ! \( -path "*/.git*" -prune \) -and ! \( -path "*/.idea*" \) -and ! \( -path "*/build/*" \)'
alias 'hist=history | less'

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
alias ps1.short="export "PS1=\$PS1SHORT""

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

# this unzips a tar file and opens the extracted folder for checking
# 1) read the file name
# 2) check if it exists
# 3) check if $TMP exists
# 4) unzip
# 5) open folder
# 6) go back to the previous folder
function unzip._command() {
    unzipCommand=$1
    if [ -z "$unzipCommand" ]; then
        echo Please enter unzipCommand
        return 1
    fi

    if [ -f "$unzipCommand" ]; then
        echo Usage: unzip.command 'tar -xzf' 'file.tar.gz'
        return 1
    fi
    # 1)
    echo 'Reading file name'
    file=$2
    CURR=`pwd`
    if [ -z "$file" ]; then
        read -p "Enter a file :" file
    fi
    # 2)
    echo 'Checking file existence'
    if [ ! -f "$file" ]; then
        echo File $file does not exist
        return 1
    fi
    # 3)
    echo 'Checking if $TMP exists'
    if [ -z "$TMP" ]; then
        echo 'Please set $TMP'
        return 1
    fi
    # 4)
    echo 'unzipping'
    fileName=$(basename "$file")
    folder=$TMP/unzip
    if [ -f "$folder" ]; then
        echo "$folder should be a folder"
        return 1
    fi
    rm -rf $folder
    mkdir $folder
    cp $file $folder
    cd $folder
    eval "$unzipCommand $fileName"
    rm $fileName
    # 5)
    echo 'Openning zipped folder'
    open .
    # 6)
    cd $CURR
    unset fileName
    unset folder
    unset CURR
    unset file
    unset unzipCommand
}

# this unzips a tar file
function unzip.tar() {
    unzip._command 'tar -xzf' $1
}

# this unzips a zipped file
function unzip.zip() {
    unzip._command 'unzip -q' $1
}

# this unzips a jar file
function unzip.jar() {
    unzip._command 'jar -xf' $1
}
