# ~/.zshrc
# works in conjunction with extra/grml-zsh-config
#
# general setup stuff

# pretty colors
BLD="\e[01m" RED="\e[01;31m" NRM="\e[00m"

echo -e "\x1B]2;$(whoami)@$(uname -n)\x07";
export MPD_HOST=$(ip addr show br0 | grep -m1 inet | awk -F' ' '{print $2}' | sed 's/\/.*$//')
bindkey -v

PATH=$PATH:$HOME/bin

# if on workstation extend PATH
[[ -d $HOME/bin/makepkg ]] &&
PATH=$PATH:$HOME/bin/makepkg:$HOME/bin/mounts:$HOME/bin/repo:$HOME/bin/benchmarking:$HOME/bin/chroots:$HOME/bin/backup

[[ -x /usr/bin/archey3 ]] && archey3

# use middle-click for pass rather than clipboard
export PASSWORD_STORE_X_SELECTION=primary
export PASSWORD_STORE_CLIP_TIME=10
export ASPROOT=$HOME/.config/asp

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

FF() {
  if [[ -n "$1" ]]; then
    find . -type f -printf "%TY%Tm%Td\t%p\n" | grep -i "$1"
  else
    return 1
  fi
}

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search

alias dh='dirs -v'

# systemd aliases and functions
alias t3='sudo systemctl isolate multi-user.target'
alias t5='sudo systemctl isolate graphical.target'

listd() {
  echo -e "${BLD}${RED} --> SYSTEM LEVEL <--${NRM}"
  find /etc/systemd/system -mindepth 1 -type d | sed '/getty.target/d' | xargs ls -gG --color
  [[ -d "$HOME"/.config/systemd/user/default.target.wants ]] &&
    (echo -e "${BLD}${RED} --> USER LEVEL <--${NRM}" ; \
    find "$HOME"/.config/systemd/user -mindepth 1 -type d | xargs ls -gG --color)
}

# systemlevel
start() { sudo systemctl start "$1"; }
stop() { sudo systemctl stop "$1"; }
restart() { sudo systemctl restart "$1"; }
status() { sudo systemctl status "$1"; }
enabled() { sudo systemctl enable "$1"; listd; }
disabled() { sudo systemctl disable "$1"; listd; }

Start() { sudo systemctl start "$1"; sudo systemctl status "$1"; }
Stop() { sudo systemctl stop "$1"; sudo systemctl status "$1"; }
Restart() { sudo systemctl restart "$1"; sudo systemctl status "$1"; }

# userlevel
ustart() { systemctl --user start "$1"; }
ustop() { systemctl --user stop "$1"; }
ustatus() { systemctl --user status "$1"; }
uenabled() { systemctl --user enable "$1"; }
udisabled() { systemctl --user disable "$1"; }

# general aliases and functions
alias ls='ls --group-directories-first --color'
alias ll='ls -lhF'
alias la='ls -lha'
alias lt='ls -lhtr'
alias lta='ls -lhatr'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias xx='exit'
alias scp='scp -p'
alias v='vim'
alias vd='vimdiff'
alias wget='wget -c'
alias grep='grep --color=auto'
alias zgrep='zgrep --color=auto'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias git='noglob git'
alias find='noglob find'
alias yt='noglob youtube-dl -q'

alias pg='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | grep -i'
alias ma='cd /home/stuff/aur4'
alias na='cd /home/stuff/my_pkgbuild_files'
alias lx='sudo lxc-ls -f'
alias mpd='sudo systemctl start mpd'

r0() { find . -type f -size 0 -print0 | xargs -0 rm -f; }

pagrep() {
  [[ -z "$1" ]] && echo 'Define a grep string and try again' && return 1
   find . -type f -type f -not -iwholename '*.git*' -print0 | xargs -0 grep --color=auto "$1"
}

fix() {
  [[ -d "$1" ]] &&
  find "$1" -type d -print0 | xargs -0 chmod 755 && find "$1" -type f -print0 | xargs -0 chmod 644 ||
    echo "$1 is not a directory."
}

fixp() {
  [[ -d "$1" ]] &&
  find "$1" -type d -print0 | xargs -0 chmod 700 && find "$1" -type f -print0 | xargs -0 chmod 600 ||
    echo "$1 is not a directory."
}

x() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.lrz)
        b=$(basename "$1" .tar.lrz)
        lrztar -d "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.lrz)
        b=$(basename "$1" .lrz)
        lrunzip "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.tar.bz2)
        b=$(basename "$1" .tar.bz2)
        bsdtar xjf "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.bz2)
        b=$(basename "$1" .bz2)
        bunzip2 "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.tar.gz)
        b=$(basename "$1" .tar.gz)
        bsdtar xzf "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.gz)
        b=$(basename "$1" .gz)
        gunzip "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.tar.xz)
        b=$(basename "$1" .tar.xz)
        bsdtar Jxf "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.xz)
        b=$(basename "$1" .gz)
        xz -d "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.rar)
        b=$(basename "$1" .rar)
        unrar e "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.tar)
        b=$(basename "$1" .tar)
        bsdtar xf "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.tbz2)
        b=$(basename "$1" .tbz2)
        bsdtar xjf "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.tgz)
        b=$(basename "$1" .tgz)
        bsdtar xzf "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.zip)
        b=$(basename "$1" .zip)
        unzip "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.Z)
        b=$(basename "$1" .Z)
        uncompress "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.7z)
        b=$(basename "$1" .7z)
        7z x "$1" && [[ -d "$b" ]] && cd "$b" || return 0 ;;
      *.deb)
        b=$(basename "$1" .deb)
        ar x "$1" && return 0 ;;
      *) echo "don't know how to extract '$1'..." && return 1 ;;
    esac
    return 0
  else
    echo "'$1' is not a valid file!"
    return 1
  fi
}

# less general
# probably want to delete most of these as they are specific to my needs

bi() {
  [[ -d "$1" ]] && {
   cp -a "$1" /scratch
   cd /scratch/"$1"
 } || return 1
}

aur() {
  [[ -f PKGBUILD ]] || return 1
  source PKGBUILD
  mksrcinfo
  git commit -am "Update to $pkgver-$pkgrel"
  git push
}

justbump() {
  [[ -f PKGBUILD ]] || return 1
  source PKGBUILD
  new=$(( pkgrel + 1 ))
  sed -i "s/^pkgrel=.*/pkgrel=$new/" PKGBUILD
  echo ">>>        Old pkgrel is $pkgrel and new is $new"
  echo
}

alias sums='/usr/bin/updpkgsums && chmod 644 PKGBUILD && rm -rf src'
alias ccm='sudo ccm64'
alias hddtemp='sudo hddtemp'
alias nets='sudo netstat -nlptu'
alias nets2='sudo lsof -i'

# pacman and package related
# update with fresh mirror list
upp() {
  for i in 1 2 4 8; do
    if reflector -c US -a $i -f 5 -p http -p https -p ftp --sort rate --save /etc/pacman.d/mirrorlist.reflector; then
      cat /etc/pacman.d/mirrorlist.reflector
      sudo pacman -Syu
      cower --ignorerepo=router -u
      return 0
    else
      echo "something is fucked up"
    fi
  done
}

alias orphans='[[ -n $(pacman -Qdt) ]] && sudo pacman -Rs $(pacman -Qdtq) || echo "no orphans to remove"'
alias bb='sudo bleachbit --clean system.cache system.localizations system.trash ; sudo paccache -vrk 3 || return 0'
alias bb2='bleachbit --clean chromium.cache chromium.dom thumbnails.cache'
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

# my svn alternative to ABS
# https://github.com/graysky2/getpkg
[[ -f /home/stuff/my_pkgbuild_files/getpkg/getpkg ]] && \
  . /home/stuff/my_pkgbuild_files/getpkg/getpkg

# ssh shortcuts
alias sbe="$HOME/bin/s be"
alias sba="$HOME/bin/s ba"

alias sm="$HOME/bin/s m"
alias sS="$HOME/bin/s S"

alias sc="$HOME/bin/s c"
alias sd="$HOME/bin/s d"
alias sr="$HOME/bin/s r"
alias sw="$HOME/bin/s w"
alias sv="$HOME/bin/s v"
alias ssu="$HOME/bin/s sub"
alias sod="$HOME/bin/s sod"
alias sop="$HOME/bin/s sop"

alias sp="$HOME/bin/s p"
alias sp1="$HOME/bin/s p1"
alias sp2="$HOME/bin/s p2"
alias sp3="$HOME/bin/s p3"

alias sa="$HOME/bin/s a"
alias sj="$HOME/bin/s j"
alias srepo="$HOME/bin/s repo"
alias sm1="$HOME/bin/s mo"
alias sm2="$HOME/bin/s mo2"
alias sm3="$HOME/bin/s mo3"

# vim:set ts=2 sw=2 et:
