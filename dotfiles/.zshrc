# ~/.zshrc
# works in conjunction with extra/grml-zsh-config
#
# general setup stuff

# pretty colors
BLD="\e[01m" RED="\e[01;31m" GRN="\e[01;32m" BLU="\e[01;34m" NRM="\e[00m"

echo -e "\x1B]2;$(whoami)@$(uname -n)\x07";
export MPD_HOST=$(ip addr show br0 | grep -m1 inet | awk -F' ' '{print $2}' | sed 's/\/.*$//')
bindkey -v

[[ -z "$PS1" ]] && return
[[ -f /etc/profile ]] && . /etc/profile

TERM=xterm-256color
PATH=$PATH:$HOME/bin

# if on workstation extend PATH
[[ -d $HOME/bin/makepkg ]] && 
PATH=$PATH:$HOME/bin/browsers:$HOME/bin/makepkg:$HOME/bin/mounts:$HOME/bin/repo:$HOME/bin/benchmarking:$HOME/bin/chroots:$HOME/bin/backup

[[ -x /usr/bin/archey3 ]] && archey3 --config=$HOME/.config/archey3.cfg

#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# use multithreaded xz
#export XZ_OPTS="-T 8"

# history stuff
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

# fix zsh annoying history behavior
h() { if [ -z "$*" ]; then history 1; else history 1 | egrep "$@"; fi; }

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search

# systemd aliases and functions
alias t3='sudo systemctl isolate multi-user.target'
alias t5='sudo systemctl isolate graphical.target'

listd() {
	echo -e ${BLD}${RED}" --> SYSTEM LEVEL <--"${NRM}
	find /etc/systemd/system -mindepth 1 -type d | sed '/getty.target/d' | xargs ls -gG --color
	[[ $(find $HOME/.config/systemd/user -mindepth 1 -type d | wc -l) -eq 0 ]] ||
		(echo -e ${BLD}${RED}" --> USER LEVEL <--"${NRM} ; \
		find $HOME/.config/systemd/user -mindepth 1 -type d | xargs ls -gG --color)
}

# systemlevel
start() { sudo systemctl start $1.service; }
stop() { sudo systemctl stop $1.service; }
restart() { sudo systemctl restart $1.service; }
status() { sudo systemctl status $1.service; }
enabled() { sudo systemctl enable $1.service; listd; }
disabled() { sudo systemctl disable $1.service; listd; }

Start() { sudo systemctl start $1.service; sudo systemctl status $1.service; }
Stop() { sudo systemctl stop $1.service; sudo systemctl status $1.service; }
Restart() { sudo systemctl restart $1.service; sudo systemctl status $1.service; }

# userlevel
startu() { systemctl --user start $1.service; }
stopu() { systemctl --user stop $1.service; }
enabledu() { systemctl --user enable $1.service; }
disabledu() { systemctl --user disable $1.service; } 

# general aliases and functions
alias pg='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | grep --color=auto'
alias scp='scp -p'
alias v='vim'
alias vd='vimdiff'
alias xx='exit'
alias wget='wget -c'
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias ma='cd /home/stuff/aur4'
alias ls='ls --group-directories-first --color'
alias ll='ls -lhF'
alias la='ls -lha'
alias lt='ls -lhtr'
alias lta='ls -lhatr'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

r0() { find . -type f -size 0 -print0 | xargs -0 rm -f; }

# parallel grep is a very fast implementation using gnu parallel
pagrep() {
	[[ -z "$1" ]] && echo 'Define a grep string and try again' && return 1
	find . -type f | parallel -k -j150% -n 1000 -m grep -H -n "$1" {}
}

tailc() { tail -n 40 "$1" | column -t; }

fix() {
	if [[ -d "$1" ]]; then
		find "$1" -type d -print0 | xargs -0 chmod 755 && find "$1" -type f -print0 | xargs -0 chmod 644
	else
		echo "$1 is not a directory."
	fi
}

x() {
	if [[ -f "$1" ]]; then
		case "$1" in
			*.tar.lrz)
				b=$(basename "$1" .tar.lrz)
				lrztar -d "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.lrz)
				b=$(basename "$1" .lrz)
				lrunzip "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar.bz2)
				b=$(basename "$1" .tar.bz2)
				bsdtar xjf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.bz2)
				b=$(basename "$1" .bz2)
				bunzip2 "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar.gz)
				b=$(basename "$1" .tar.gz)
				bsdtar xzf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.gz)
				b=$(basename "$1" .gz)
				gunzip "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar.xz)
				b=$(basename "$1" .tar.xz)
				bsdtar Jxf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.xz)
				b=$(basename "$1" .gz)
				xz -d "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.rar)
				b=$(basename "$1" .rar)
				unrar e "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar)
				b=$(basename "$1" .tar)
				bsdtar xf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tbz2)
				b=$(basename "$1" .tbz2)
				bsdtar xjf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tgz)
				b=$(basename "$1" .tgz)
				bsdtar xzf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.zip)
				b=$(basename "$1" .zip)
				unzip "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.Z)
				b=$(basename "$1" .Z)
				uncompress "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.7z)
				b=$(basename "$1" .7z)
				7z x "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*) echo "don't know how to extract '$1'..." && return 1;;
		esac
		return 0
	else
		echo "'$1' is not a valid file!"
		return 1
	fi
}

# less general
# probably want to delete most of these as they are specific to my needs and systems
yt() { [[ -z "$1" ]] && return 1 || youtube-dl -q "$1" &; }
bi() { cp -a "$1" /scratch ; cd /scratch/"$1"; }

aur() {
	[[ -f PKGBUILD ]] || exit 1
	source PKGBUILD
	mksrcinfo
	git commit -am "Update to $pkgver-$pkgrel"
	git push
}

alias sums='/usr/bin/updpkgsums && chmod 644 PKGBUILD && rm -rf src'
alias ccm='sudo ccm'
alias ccm64='sudo ccm64'
alias ccm32='sudo ccm32'
alias hddtemp='sudo hddtemp'

alias vbup='start vbox'
alias nets='sudo netstat -nlptu'
alias nets2='sudo lsof -i'

# pacman and package related
# update with fresh mirror list
alias upp='reflector -c "United States" -a 1 -f 3 --sort rate --save /etc/pacman.d/mirrorlist.reflector && cat /etc/pacman.d/mirrorlist.reflector && sudo pacman -Syyu && cower --ignorerepo=router -u'
# write out a good default if reflector fails
alias fpp="echo 'Server = http://mirror.us.leaseweb.net/archlinux/\$repo/os/\$arch' > /etc/pacman.d/mirrorlist.reflector && pp"

alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'
alias bb='sudo bleachbit --clean system.cache system.localizations system.trash && sudo rm -rf /usr/share/gtk-doc && sudo rm -rf /usr/share/doc && sudo paccache -vrk 2 || return 0'
alias makepkg='nice -19 makepkg'

# update
alias pp='sudo pacman -Syu && cower --ignorerepo=router -u'

signit() {
	if [[ -z "$1" ]]; then
		echo "Provide a filename and try again."
	else
		file="$1"
		target_dts=$(date -d "$(stat -c %Y $file | awk '{print strftime("%c",$1)}')" +%Y%m%d%H%M.%S) && \
			gpg --detach-sign --local-user 5EE46C4C "$file" && \
			touch -t "$target_dts" "$file.sig"
	fi
}

# github shortcuts
alias gitc='git commit -av'

clone() {
	[[ -z "$1" ]] && echo "provide a repo name" && return 1
	git clone git://github.com/graysky2/"$1".git
	#git clone --depth 1 https://github.com/graysky2/"$1".git
	cd "$1"
	[[ ! -f .git/config ]] && echo "no git config" && return 1
	grep git: .git/config &>/dev/null
	[[ $? -gt 0 ]] && echo "no need to fix config" && return 1
	sed -i '/url =/ s,://github.com/,@github.com:,' .git/config
}

# my svn alterantive to ABS
# https://gist.github.com/graysky2/123a92d045bb02ce7634
[[ -f /home/stuff/my_pkgbuild_files/getpkg/getpkg ]] && \
	source /home/stuff/my_pkgbuild_files/getpkg/getpkg

# ssh shortcuts
alias sp="$HOME/bin/s p"
alias sd="$HOME/bin/s d"
alias sW="$HOME/bin/s W"
alias sa="$HOME/bin/s a"
alias sc="$HOME/bin/s c"
alias sj="$HOME/bin/s j"
alias sj2="$HOME/bin/s j2"
alias sr="$HOME/bin/s r"
alias spi="$HOME/bin/s pi"
alias sn="$HOME/bin/s n"
alias sm="$HOME/bin/s m"
alias sw="$HOME/bin/s w"
alias srepo="$HOME/bin/s repo"
alias sv="$HOME/bin/s v"
alias smom="$HOME/bin/s mom"

