for i in aliases bashrc2 commonrc functions zsh ; do [[ -f $HOME/.$i ]] && . $HOME/.$i ; done
for i in $HOME/.zsh/* ; do . "$i" ; done

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '

# enable tab completion
autoload -U compinit
compinit -i
