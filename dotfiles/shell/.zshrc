ZSH=$HOME/.zsh
[[ -f $HOME/.zsh/zsh-syntax-highlighting/*.zsh ]] && . $HOME/.zsh/zsh-syntax-highlighting/*.zsh	# https://github.com/zsh-users/zsh-syntax-highlighting
for config_file ($ZSH/lib/*.zsh) source $config_file	# load zsh specific stuff

for i in aliases bashrc2 commonrc functions zsh; do 
	[[ -f $HOME/.$i ]] && . $HOME/.$i;
done

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '
#PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}facade@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '

REPORTTIME=5	# report about cpu-/system-/user-time of command if running longer than 5 seconds
autoload -U compinit
compinit -i
zstyle ':completion:*' rehash yes
