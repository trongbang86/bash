echo 'Running .bash_profile'

[ -f ~/.bash_profile_before ] && echo Calling ~/.bash_profile_before && source ~/.bash_profile_before

[ "$T2F" == "" ] && echo 'You have not set up $T2F'

source ~/bash/macos.sh

source ~/bash/keys.sh

[ "$(which gradle)" != "" ] && echo Calling ~/bash/gradle.sh && source ~/bash/gradle.sh

[ -f ~/.bash_profile_after ] && echo Calling ~/.bash_profile_after && source ~/.bash_profile_after

echo 'Finished .bash_profile'
