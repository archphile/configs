echo -e "\x1B]2;$(whoami)@$(uname -n)\x07"; # set terminal title

[[ -z "$PS1" ]] && return
[[ -f /etc/profile ]] && . /etc/profile
[[ -f $HOME/.bashrc2 ]] && . $HOME/.bashrc2
[[ -f $HOME/.functions ]] && . $HOME/.functions
[[ -f $HOME/.aliases ]] && . $HOME/.aliases
for i in $HOME/.zsh/* ; do . "$i" ; done

PATH=$PATH:$HOME/bin:$HOME/bin/browsers:$HOME/bin/makepkg:$HOME/bin/mounts:$HOME/bin/repo:$HOME/bin/benchmarking

autoload -U compinit
compinit -i

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '

TERM=xterm-256color
export EDITOR=vim
export VISUAL=vim
set -o vi

bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del

archey
