#!/bin/bash

BASH_PROFILE_BEFORE=~/custom_bash/.bash_profile_before
BASH_PROFILE_AFTER=~/custom_bash/.bash_profile_after
BASH_PROFILE_PLAIN=~/custom_bash/.bash_profile_plain
PS1_FLAG_USED=0
echo 'Running .bash_profile'

function call_file() {
    [ -f "$1" ] && source "$1"
}

function abp() {
    PS1_TMP=$PS1

    call_file $BASH_PROFILE_BEFORE

    [ "$T2F" == "" ] && echo 'You have not set up $T2F'

    source ~/bash/debug.sh
    source ~/bash/keys.sh
    source ~/bash/ssh.sh
    source ~/bash/git.sh
    source ~/bash/sftp.sh
    source ~/bash/java.sh
    source ~/bash/zip.sh

    call_file $BASH_PROFILE_AFTER

    [ "$PS1LONG" == "" ] && echo 'You have not set up $PS1LONG'
    [ "$PS1MEDIUM" == "" ] && echo 'You have not set up $PS1MEDIUM'
    [ "$PS1SHORT" == "" ] && echo 'You have not set up $PS1SHORT'

    [ "$PS1_FLAG_USED" == "1" ] && export PS1=$PS1_TMP

    unset PS1_TMP
    PS1_FLAG_USED=1

}

call_file $BASH_PROFILE_PLAIN

echo 'Finished .bash_profile'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/bang/.sdkman"
[[ -s "/Users/bang/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/bang/.sdkman/bin/sdkman-init.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
