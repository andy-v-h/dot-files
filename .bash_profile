#export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\W\[\033[m\]\$ "

export CLICOLOR=1
export LSCOLORS=exfxcxdxbxegedabagacad
#export LSCOLORS=GxFxCxDxBxegedabagaced

alias ls='ls' 
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -la'

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
export GOPATH="/home/aholtzma/Documents/src/go/"


if ! shopt -oq posix; then
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi
fi
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
eval "$(chef shell-init bash)"

export PATH="$HOME/.cargo/bin:$PATH"
