echo -e "\x1B]2;$(whoami)@$(uname -n)\x07"; # set terminal title
[[ -z "$PS1" ]] && return
[[ -f /etc/profile ]] && . /etc/profile

for i in aliases bashrc2 functions zsh ; do [[ -f $HOME/.$i ]] && . $HOME/.$i ; done
for i in $HOME/.zsh/* ; do . "$i" ; done

TERM=xterm-256color
PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '

PATH=$PATH:$HOME/bin:$HOME/bin/browsers:$HOME/bin/makepkg:$HOME/bin/mounts:$HOME/bin/repo:$HOME/bin/benchmarking

bindkey -v # set vim bindings
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward


autoload -U compinit
compinit -i
archey

