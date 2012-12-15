[[ -f $HOME/.bashrc2 ]] && . $HOME/.bashrc2
[[ -f $HOME/.functions ]] && . $HOME/.functions
[[ -f $HOME/.commonrc ]] && . $HOME/.commonrc
[[ -f $HOME/.aliases ]] && . $HOME/.aliases

export CHROOT=/scratch/chroot64
export EDITOR=vim
export VISUAL=vim
set -o vi

PS1='[\u@\h \W]\$ '

# uncomment if using laptop
#PS1="[\$(~/bin/battery_status] ] \u@\h:\w \$ "

# make multiple shells share the same history file
shopt -s histappend
export PROMPT_COMMAND="history -a ; ${PROMPT_COMMAND:-:}"
export HISTCONTROL=erasedups
export HISTSIZE=10000
