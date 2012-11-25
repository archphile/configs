ZSH=$HOME/.zsh

# load zsh specific stuff
for config_file ($ZSH/lib/*.zsh) source $config_file

# load syntax highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting
. $HOME/.zsh/zsh-syntax-highlighting/*.zsh

# load legacy stuff
for i in aliases bashrc2 commonrc functions zsh ; do [[ -f $HOME/.$i ]] && . $HOME/.$i ; done

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '

# enable tab completion
autoload -U compinit
compinit -i

# report about cpu-/system-/user-time of command if running longer than
# 5 seconds
REPORTTIME=5
