
alias 'cd.=cd ~'
alias 'cl=clear'
alias 'vbp=vim ~/.bash_profile'
alias 'vbpa=vim ~/.bash_profile_after'
alias 'vteamocil=vim ~/.teamocil'
alias 'abp=source ~/.bash_profile'
alias 'v.=vim .'
alias 'vbash=vim ~/bash'
alias 'find.no.git=find . ! \( -ipath "^\.git*" \)'
alias 't2f=tee /tmp/t2f.txt'
alias 'gs=git -c color.status=always status | less -R'
gd() { git diff --color=always "$@" | less -R; }
alias 'gl=git log --color=always | less -R'
alias 'ga=git add'
alias 'gc=git commit -m'
alias 'gp=git push'
gb() { git branch "$@" | less; }
alias 'hist=history | less'
alias ps1.long="export "PS1=\$PS1LONG""
alias ps1.short="export "PS1=\$PS1SHORT""
