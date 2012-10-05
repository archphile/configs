ZSH=$HOME/.zsh
#fpath=($ZSH/functions $ZSH/completions $fpath)

# load zsh specific stuff
for config_file ($ZSH/lib/*.zsh) source $config_file

# load legacy stuff
for i in aliases bashrc2 commonrc functions zsh ; do [[ -f $HOME/.$i ]] && . $HOME/.$i ; done

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '

# enable tab completion
autoload -U compinit
compinit -i
