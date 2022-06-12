#!/bin/sh

status() {
  echo " $(pamixer --default-source --get-volume-human)"
}

listen() {
    status

    LANG=EN; pactl subscribe | while read -r event; do
        if echo "$event" | grep -q "source" || echo "$event" | grep -q "server"; then
            status
        fi
    done
}

case "$1" in
    --toggle)
        pamixer --default-source --toggle-mute
        ;;
    --increase)
        pamixer --default-source --increase 10
        ;;
    --decrease)
        pamixer --default-source --decrease 10
        ;;
    *)
        listen
        ;;
esac
