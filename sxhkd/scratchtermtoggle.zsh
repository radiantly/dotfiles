#!/usr/bin/zsh
#set -xv
if ! xdotool search --class scratchterm; then
    kitty --class scratchterm --title scratchterm -c ~/.config/kitty/kitty.conf -c ~/.config/kitty/almostopaque.conf &
    sleep 0.5
fi
xdotool search --class scratchterm | xargs -i bspc node {} --flag hidden -f
