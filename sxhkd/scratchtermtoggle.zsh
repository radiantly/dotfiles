#!/usr/bin/zsh
#set -xv
id=$(xdotool search --class scratchterm)

if [[ "$id" == "" ]]; then
    kitty --class scratchterm --title scratchterm &
    sleep 0.5 && id=$(xdotool search --class scratchterm)
fi
bspc node "$id" --flag hidden -f
