echo -e "\x1B]2;$(whoami)@$(uname -n)\x07"; # set gnometerminal title

[ -f /etc/profile ] && . /etc/profile
[ -f /etc/bash_completion ] && . /etc/profile
[ -z "$PS1" ] && return

export EDITOR=vim
export VISUAL=vim
set -o vi
PS1='[\u@\h \W]\$ '

PATH=$PATH:$HOME/bin:$HOME/bin/wine

# make multiple shells share the same history file
shopt -s histappend
PROMPT_COMMAND='history -a'
export HISTCONTROL=erasedups
export HISTSIZE=1000

alias 64="xterm -T \"DISTCC Status for x86_64\" -bg black -fg white -e watch distccmon-text&"
alias pacman="pacman-color"
alias aur="aurploader -r -l ~/.aurploader"
alias bb="sudo bleachbit --delete system.cache system.localizations system.trash system.tmp"
alias pp="sudo pacman-color -Syu"
alias cc="sudo cacheclean 2"
alias ls="ls --color=auto"
alias grep="grep --color=auto"

alias ma="cd /home/stuff/my_pkgbuild_files"
alias ll="ls -lh"
alias la="ls -lha"
alias rm="rm -i"
alias mv="mv -i"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias qs="qstat -n"
alias n="pbsnodes"
alias 0q="sudo qmgr -c \"set server next_job_number = 0 \""

alias memrss='while read command percent rss; do if [[ "${command}" != "COMMAND" ]]; then rss="$(bc <<< "scale=2;${rss}/1024")"; fi; printf "%-26s%-8s%s\n" "${command}" "${percent}" "${rss}"; done < <(ps -A --sort -rss -o comm,pmem,rss | head -n 20)'

alias pg='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | grep --color=auto'
alias pm='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | sort -rnk 6 | head -n 10'

alias hddtemp="sudo hddtemp"
alias nets="sudo netstat -nlpt"
alias nets2="sudo lsof -i"

start() { 
sudo rc.d start $1
}

restart() { 
sudo rc.d restart $1
}

stop() { 
sudo rc.d stop $1
}

bi () {
cp -a $1 /dev/shm
cd /dev/shm/$1
here=`pwd`
echo you are here $here
}

x () {
   if [ -f $1 ] ; then
       case $1 in
	*.lrz)		lrztar -d $1 && cd $(basename "$1" .lrz) ;;
	*.tar.bz2)	tar xvjf $1 && cd $(basename "$1" .tar.bz2) ;;
	*.tar.gz)	tar xvzf $1 && cd $(basename "$1" .tar.gz) ;;
	*.tar.xz)	tar Jxvf $1 && cd $(basename "$1" .tar.xz) ;;
	*.bz2)		bunzip2 $1 && cd $(basename "$1" /bz2) ;;
	*.rar)		unrar x $1 && cd $(basename "$1" .rar) ;;
	*.gz)		gunzip $1 && cd $(basename "$1" .gz) ;;
	*.tar)		tar xvf $1 && cd $(basename "$1" .tar) ;;
	*.tbz2)		tar xvjf $1 && cd $(basename "$1" .tbz2) ;;
	*.tgz)		tar xvzf $1 && cd $(basename "$1" .tgz) ;;
	*.zip)		unzip $1 && cd $(basename "$1" .zip) ;;
	*.Z)		uncompress $1 && cd $(basename "$1" .Z) ;;
	*.7z)		7z x $1 && cd $(basename "$1" .7z) ;;
	*)		echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

fix() {
  if [ -d $1 ]; then
    find $1 -type d -exec chmod 755 {} \;
    find $1 -type f -exec chmod 644 {} \;
  else
    echo "$1 is not a directory."
  fi
}

archey3
#alsi -a
