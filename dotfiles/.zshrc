# ~/.zshrc
# works in conjunction with extra/grml-zsh-config
#

# general setup stuff
echo -e "\x1B]2;$(whoami)@$(uname -n)\x07";
export MPD_HOST=$(ip addr show eno1 | grep -m1 inet | awk -F' ' '{print $2}' | sed 's/\/.*$//')
bindkey -v

[[ -z "$PS1" ]] && return
[[ -f /etc/profile ]] && . /etc/profile

# default grml config takes precedence over autojump
[[ -f /etc/zsh/zshrc ]] && unalias j
TERM=xterm-256color

PATH=$PATH:$HOME/bin

# if on workstation extend PATH
[[ -d $HOME/bin/makepkg ]] && 
PATH=$PATH:$HOME/bin/browsers:$HOME/bin/makepkg:$HOME/bin/mounts:$HOME/bin/repo:$HOME/bin/benchmarking:$HOME/bin/chroots:$HOME/bin/backup

[[ -x /usr/bin/archey3 ]] &&
archey3 --config=$HOME/.config/archey3.cfg

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
alias listd='find /etc/systemd/system -mindepth 1 -type d | xargs ls -l --color'

start() { sudo systemctl start $1.service; sudo systemctl status $1.service; }
stop() { sudo systemctl stop $1.service; sudo systemctl status $1.service; }
restart() { sudo systemctl restart $1.service; sudo systemctl status $1.service; }
status() { sudo systemctl status $1.service; }
enable() { sudo systemctl enable $1.service; listd; }
disable() { sudo systemctl disable $1.service; listd; }

# general aliases and functions
alias pg='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | grep --color=auto'
alias scp='scp -p'
alias v='vim'
alias vd='vimdiff'
alias xx='exit'
alias wget='wget -c'
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias ma='cd /home/stuff/my_pkgbuild_files'
alias ls='ls --group-directories-first --color'
alias ll='ls -lh'
alias la='ls -lha'
alias lt='ls -lhtr'
alias lta='ls -lhatr'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias memrss='while read command percent rss; do if [[ "${command}" != "COMMAND" ]]; \
then rss="$(bc <<< "scale=2;${rss}/1024")"; fi; printf "%-26s%-8s%s\n" "${command}" "${percent}" "${rss}"; \
done < <(ps -A --sort -rss -o comm,pmem,rss | head -n 20)'

r0() { find . -type f -size 0 -print0 | xargs -0 rm -f; }

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
				tar xjf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.bz2)
				b=$(basename "$1" .bz2)
				bunzip2 "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar.gz)
				b=$(basename "$1" .tar.gz)
				tar xzf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.gz)
				b=$(basename "$1" .gz)
				gunzip "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar.xz)
				b=$(basename "$1" .tar.xz)
				tar Jxf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.xz)
				b=$(basename "$1" .gz)
				xz -d "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.rar)
				b=$(basename "$1" .rar)
				unrar e "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tar)
				b=$(basename "$1" .tar)
				tar xf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tbz2)
				b=$(basename "$1" .tbz2)
				tar xjf "$1" && [[ -d "$b" ]] && cd "$b" ;;
			*.tgz)
				b=$(basename "$1" .tgz)
				tar xzf "$1" && [[ -d "$b" ]] && cd "$b" ;;
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

# less general aliases
alias youtube-dl='noglob youtube-dl'
alias ytq="noglob youtube-dl -F $1"
alias nets='sudo netstat -nlptu'
alias nets2='sudo lsof -i'

alias ccm='sudo ccm'
alias ccm64='sudo ccm64'
alias ccm32='sudo ccm32'
alias hddtemp='sudo hddtemp'
alias vup='vbox-headless-daemon start'
alias vdo='vbox-headless-daemon stop'

alias aur='aurploader -r -l ~/.aurploader && rm -rf src *.src.tar.gz'
alias sums='/usr/bin/updpkgsums && rm -rf src'
alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'
alias bb='sudo bleachbit --clean system.cache system.localizations system.trash && sudo paccache -vrk 3 || return 0'
alias pp='sudo pacman -Syu && cower --ignorerepo=router -u'
alias upp='reflector -c "United States" -a 1 -f 3 --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && sudo pacman -Syyu && cower --ignorerepo=router -u'
alias fpp="echo 'Server = http://mirror.us.leaseweb.net/archlinux/\$repo/os/\$arch' > /etc/pacman.d/mirrorlist && pp"
bi() { cp -a "$1" /scratch ; cd /scratch/"$1"; }

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

# ssh shortcuts
alias sa="$HOME/bin/s a"
alias sc="$HOME/bin/s c"
alias sl="$HOME/bin/s l"
alias sj="$HOME/bin/s j"
alias sj2="$HOME/bin/s j2 "
alias sn="$HOME/bin/s n"
alias sm="$HOME/bin/s m"
alias smom="$HOME/bin/s mom"
alias sr="$HOME/bin/s r"
alias srepo="$HOME/bin/s repo"
alias sw="$HOME/bin/s w"
alias sp="$HOME/bin/s p"
alias sx="$HOME/bin/s x"
alias sxx="$HOME/bin/s xx"

# github shortcuts
alias gitc='git commit -av ; git push -u origin master'
clone() {
	[[ -z "$1" ]] && echo "provide a repo name" && return 1
	git clone git://github.com/graysky2/"$1".git
	cd "$1"
	[[ ! -f .git/config ]] && echo "no git config" && return 1
	grep git: .git/config &>/dev/null
	[[ $? -gt 0 ]] && echo "no need to fix config" && return 1
	sed -i '/url =/ s,://github.com/,@github.com:,' .git/config
}

getpkg() {
	if [[ -z "$1" ]]; then
		echo "Supply a package name and try again."
	else
		cd /scratch
		[[ -d "/scratch/packages/$1" ]] && rm -rf "/scratch/packages/$1"
		svn checkout --depth=empty svn://svn.archlinux.org/packages && cd packages
		svn update "$1" && cd "$1"
		# compare trunk to core
		if [[ -d repos/core-x86_64 ]]; then
			cp -a repos/core-x86_64 repos/core-x86_64.mod
			cd repos/core-x86_64.mod
		elif [[ -d repos/extra-x86_64 ]]; then
			cp -a repos/extra-x86_64 repos/extra-x86_64.mod
			cd repos/extra-x86_64.mod
		elif [[ -d repos/community-x86_64 ]]; then
			cp -a repos/community-x86_64 repos/community-x86_64.mod
			cd repos/community-x86_64.mod
		fi

		# compare trunk to testing
		#if [[ -d repos/testing-x86_64 ]]; then
		# cd repos/testing-x86_64
		#elif [[ -d repos/core-x86_64 ]]; then
		# cd repos/core-x86_64
		#elif [[ -d repos/extra-x86_64 ]]; then
		# cd repos/extra-x86_64
		#elif [[ -d repos/community-x86_64 ]]; then
		# cd repos/community-x86_64
		#fi

		git init ; git add * ; git commit -m 'first commit'
		cp ../../trunk/* .
		git commit -av
	fi
}

getpkgc() {
	if [[ -z "$1" ]]; then
		echo "Supply a package name and try again."
	else
		cd /scratch
		[[ -d "/scratch/packages/$1" ]] && rm -rf "/scratch/packages/$1"
		svn checkout --depth=empty svn://svn.archlinux.org/community && cd community
		svn update "$1" && cd "$1"
	fi
}
