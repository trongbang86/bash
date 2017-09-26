echo 'Running .bash_profile'

source ~/bash/macos.sh

source ~/bash/keys.sh
[ -f ~/.bash_profile_after ] && echo Calling ~/.bash_profile_after && source ~/.bash_profile_after

echo 'Finished .bash_profile'
