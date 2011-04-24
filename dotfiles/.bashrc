if [ -f /etc/profile ]; then
    . /etc/profile
fi

. /etc/profile.d/autojump.bash # temp fix for autojump

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

alias coma="more ~/.bashrc | grep alias"
alias pacman="pacman-color"
alias aur="aurploader -r -l ~/.aurploader"

alias bb="sudo bleachbit --delete system.cache system.localizations system.trash system.tmp"
alias pp="sudo pacman-color -Syu"
alias cc="sudo cacheclean 2"

alias xcat="cat $1 | xclip -sel clip"
alias ma="cd /home/stuff/my_pkgbuild_files"
alias ll="ls -lh"
alias la="ls -lha"
alias rm="rm -i"
alias mv="mv -i"
alias rsync="rsync -P"
alias memrss='while read command percent rss; do if [[ "${command}" != "COMMAND" ]]; then rss="$(bc <<< "scale=2;${rss}/1024")"; fi; printf "%-26s%-8s%s\n" "${command}" "${percent}" "${rss}"; done < <(ps -A --sort -rss -o comm,pmem,rss | head -n 11)'
alias pmem="ps -A --sort -rss -o comm,pmem | head -n 11"

alias pg='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | grep --color=auto'
alias pm='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | sort -rnk 6 | head -n 10'
alias hddtemp="sudo hddtemp"
alias nets="sudo netstat -nlpt"
alias nets2="sudo lsof -i"

function start() { sudo /etc/rc.d/$1 start; }
function stop() { sudo /etc/rc.d/$1 stop; }
function restart() { sudo /etc/rc.d/$1 restart; }

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Check for an interactive session
[ -z "$PS1" ] && return

alias ls="ls --color=auto"
PS1='[\u@\h \W]\$ '

PATH=$PATH:/home/$USER/bin
PATH=$PATH:/home/$USER/bin/wine

bi () {
cp -a $1 /dev/shm
cd /dev/shm/$1
here=`pwd`
echo you are here $here
}

#archey3 -d 'distro.uname:r.uname:n.uptime.packages.ram.fs:/.fs:/boot.fs:/home.fs:/var.fs:/dev/shm.fs:/tmp'

python ~/bin/archey.py

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

define() {
  local LNG=$(echo $LANG | cut -d '_' -f 1)
  local CHARSET=$(echo $LANG | cut -d '.' -f 2)
  lynx -accept_all_cookies -dump -hiddenlinks=ignore -nonumbers -assume_charset="$CHARSET" -display_charset="$CHARSET" "http://www.google.com/search?hl=${LNG}&q=define%3A+${1}&btnG=Google+Search" | grep -m 5 -C 2 -A 5 -w "*" > /tmp/deleteme
  if [ ! -s /tmp/deleteme ]; then
    echo "Sorry, google doesn't know this one..."
  else
    cat /tmp/deleteme | grep -v Search
    echo ""
  fi
  rm -f /tmp/deleteme
}

fix() {
  if [ -d $1 ]; then
    find $1 -type d -exec chmod 755 {} \;
    find $1 -type f -exec chmod 644 {} \;
  else
    echo "$1 is not a directory."
  fi
}

calc() {
  echo "scale=4; $1" | bc
}
