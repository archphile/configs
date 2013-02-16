ZSH=$HOME/.zsh
# load modules
for config_file ($ZSH/lib/*.zsh) source $config_file
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
for custom_file ($HOME/.{aliases,bashrc2,commonrc,functions,functions-personal}) [[ -f $custom_file ]] && source $custom_file

# set prompt
PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '
#PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}facade@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '

# miscell tweaks not in modules
REPORTTIME=5
autoload -U compinit
compinit -i
zstyle ':completion:*' rehash yes
