echo 'Running .bash_profile'

source ~/bash/macos.sh
export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

source ~/bash/keys.sh
#alias 'ack=/usr/local/Cellar/ack/2.18/bin/ack --ackrc=/Users/bnguyen5/.ackrc'

eval "$(jenv init -)"
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

echo 'Finished .bash_profile'
