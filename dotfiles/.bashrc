echo -e "\x1B]2;$(whoami)@$(uname -n)\x07"; # set terminal title

[[ -z "$PS1" ]] && return
[[ -f /etc/profile ]] && . /etc/profile
[[ -f $HOME/.bashrc2 ]] && . $HOME/.bashrc2
[[ -f $HOME/.functions ]] && . $HOME/.functions
[[ -f $HOME/.aliases ]] && . $HOME/.aliases

PATH=$PATH:$HOME/bin:$HOME/bin/browsers:$HOME/bin/makepkg:$HOME/bin/mounts:$HOME/bin/repo:$HOME/bin/wine

TERM=xterm-256color
export CHROOT=/scratch/chroot64
export EDITOR=vim
export VISUAL=vim
set -o vi
PS1='[\u@\h \W]\$ '

# make multiple shells share the same history file
shopt -s histappend
export PROMPT_COMMAND="history -a ; ${PROMPT_COMMAND:-:}"
export HISTCONTROL=erasedups
export HISTSIZE=10000

archey
