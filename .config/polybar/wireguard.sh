#!/usr/bin/zsh

# Wireguard stats by @radiantly
# Forked from https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/vpn-wireguard-wg

# This script requires that the current user can run `sudo wg` and `sudo wg-quick` without a passwd
# prompt
# To do that, run `sudo visudo` and add the following lines:
# Cmnd_Alias WG_CMDS = /usr/bin/wg, /usr/bin/wg-quick
# USER_NAME_HERE ALL=(ALL) NOPASSWD: WG_CMDS

#  > Redirect stdout
# 2> Redirect stderr
# &> Redirect stdout and stderr

output() {
    conn_status=$(sudo wg show wg0 2>/dev/null)

    if [[ $? == "0" ]]; then
        echo -n "󰞀"
        echo "$conn_status" | sed -E -n 's/transfer.* ([0-9]+(\.[0-9])?)\S* (\w+).* ([0-9]+(\.[0-9])?)\S* (\w+).*/\1 \3 󰁅 \4 \6 󰁝/p'
    else
        echo "󰦞"
    fi
}

listen() {
    while :; do
        output
        # Use trick so that trap handlers do not need to wait for sleep to finish
        # From https://stackoverflow.com/questions/27694818/interrupt-sleep-in-bash-with-a-signal-trap
        sleep 5 &
        wait $!
    done
}

toggle() {
    if sudo wg show wg0 &> /dev/null; then
        sudo wg-quick down wg0 &> /dev/null
    else
        sudo wg-quick up wg0 &> /dev/null
    fi
}

TRAPUSR1() {
    echo "󰒘"
    toggle
}

case "$1" in
    --toggle)
        toggle
        ;;
    *)
        listen
        ;;
esac
