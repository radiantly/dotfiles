#!/usr/bin/zsh

if xdotool search --class scratchterm; then
    xdotool search --class scratchterm | xargs -i bspc node {} --flag hidden -f
else
    kitty --class scratchterm --config ~/.config/kitty/opaque.conf --detach
fi
