#!/usr/bin/zsh

wintitle=$(xtitle $(bspc query -N focused -n))
if [[ "$wintitle" =~ '.*(Mozilla Firefox|Chromium)' ]]; then
    # Close firefox/chromium tab
    xdotool keyup super+w 
    xdotool key --clearmodifiers Control_L+w 
    xinput query-state 13 | grep 'key\[133\]=down' && \
    xdotool keydown Super_L
    # ydotool key ctrl+w
elif [[ "$wintitle" == "zsh" ]]; then
    # Close kitty tab
    xdotool keyup super+w 
    xdotool key --clearmodifiers Control_L+Shift_L+w 
    xinput query-state 13 | grep 'key\[133\]=down' && \
    xdotool keydown Super_L
elif [[ "$wintitle" == "scratchterm" ]]; then
    zsh ~/.config/sxhkd/scratchtermtoggle.zsh
else
    bspc node -c
fi

