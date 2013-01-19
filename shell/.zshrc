unalias j	# keep autojump bound to j

# https://github.com/zsh-users/zsh-syntax-highlighting
[[ -f $HOME/zsh-syntax-highlighting/*.zsh ]]	&& . $HOME/zsh-syntax-highlighting/*.zsh

for i in aliases bashrc2 commonrc functions; do 
	[[ -f $HOME/.$i ]] && . $HOME/.$i;
done

#PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '
#PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}facade@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '
