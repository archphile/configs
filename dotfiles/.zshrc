echo -e "\x1B]2;$(whoami)@$(uname -n)\x07"; # set terminal title
[[ -z "$PS1" ]] && return
[[ -f /etc/profile ]] && . /etc/profile

for i in aliases bashrc2 functions zsh ; do [[ -f $HOME/.$i ]] && . $HOME/.$i ; done
for i in $HOME/.zsh/* ; do . "$i" ; done

PATH=$PATH:$HOME/bin:$HOME/bin/browsers:$HOME/bin/makepkg:$HOME/bin/mounts:$HOME/bin/repo:$HOME/bin/benchmarking
archey

TERM=xterm-256color
PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[white]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) %#%{$reset_color%} '

autoload -U compinit
compinit -i

autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -v # set vim bindings
# http://zshwiki.org/home/zle/bindkeys

typeset -A key

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]	&& bindkey 	"${key[Up]}" 			up-line-or-beginning-search
[[ -n "${key[Down]}"    ]]	&& bindkey 	"${key[Down]}"		down-line-or-beginning-search
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
zle-line-init () {
	echoti smkx
}

zle-line-finish () {
	echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish
