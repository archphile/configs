#!/bin/sh
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
exec ck-launch-session startxfce4
#exec ck-launch-session gnome-session
#enlightenment-session
