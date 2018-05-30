BASH_PROFILE_BEFORE=~/custom_bash/.bash_profile_before
BASH_PROFILE_AFTER=~/custom_bash/.bash_profile_after
BASH_PROFILE_PLAIN=~/custom_bash/.bash_profile_plain
PS1_FLAG_USED=0
echo 'Running .bash_profile'

[ -f "$BASH_PROFILE_PLAIN" ] && echo Calling  "$BASH_PROFILE_PLAIN" && source "$BASH_PROFILE_PLAIN" && echo Finished  "$BASH_PROFILE_PLAIN"

function abp() {
    PS1_TMP=$PS1

    [ -f "$BASH_PROFILE_BEFORE" ] && echo Calling  "$BASH_PROFILE_BEFORE" && source "$BASH_PROFILE_BEFORE" && echo Finished  "$BASH_PROFILE_BEFORE"

    [ "$T2F" == "" ] && echo 'You have not set up $T2F'

    source ~/bash/keys.sh
    source ~/bash/ssh.sh
    source ~/bash/git.sh
    source ~/bash/sftp.sh
    source ~/bash/macos.sh
    source ~/bash/java.sh
    source ~/bash/zip.sh

    [ "$PS1LONG" == "" ] && echo 'You have not set up $PS1LONG'
    [ "$PS1MEDIUM" == "" ] && echo 'You have not set up $PS1MEDIUM'
    [ "$PS1SHORT" == "" ] && echo 'You have not set up $PS1SHORT'

    set_ssh_agent_socket #ssh-find-agent.sh

    [ "$(which gradle)" != "" ] && echo Calling ~/bash/gradle.sh && source ~/bash/gradle.sh

    [ -f "$BASH_PROFILE_AFTER" ] && echo Calling "$BASH_PROFILE_AFTER" && source "$BASH_PROFILE_AFTER" && echo Finished "$BASH_PROFILE_AFTER"

    [ "$PS1_FLAG_USED" == "1" ] && export PS1=$PS1_TMP

    unset PS1_TMP
    PS1_FLAG_USED=1

}

echo 'Finished .bash_profile'
