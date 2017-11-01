BASH_PROFILE_BEFORE=~/custom_bash/.bash_profile_before
BASH_PROFILE_AFTER=~/custom_bash/.bash_profile_after
echo 'Running .bash_profile'

[ -f "$BASH_PROFILE_BEFORE" ] && echo Calling  "$BASH_PROFILE_BEFORE" && source "$BASH_PROFILE_BEFORE" 

[ "$T2F" == "" ] && echo 'You have not set up $T2F'

source ~/bash/macos.sh
source ~/bash/keys.sh
source ~/bash/git.sh

[ "$(which gradle)" != "" ] && echo Calling ~/bash/gradle.sh && source ~/bash/gradle.sh

[ -f "$BASH_PROFILE_AFTER" ] && echo Calling "$BASH_PROFILE_AFTER" && source "$BASH_PROFILE_AFTER"

echo 'Finished .bash_profile'
