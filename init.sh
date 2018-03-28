# 1. Initialising .bash_profile
if [ -f ~/.bash_profile ]; then
    echo '~/.bash_profile exists so not copying over'
else
    ln -s ~/bash/.bash_profile ~/.bash_profile
    echo 'ln -s ~/bash/.bash_profile ~/.bash_profile'
fi

# 2. Initialising tmux
# 2.1 Copying .tmux.conf
if [ -f ~/.tmux.conf ]; then
    echo '~/.tmux.conf exists so not copying over'
else
    ln -s ~/bash/.tmux.conf ~/.tmux.conf
    echo 'ln -s ~/bash/.tmux.conf ~/.tmux.conf'
fi
