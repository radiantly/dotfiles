#!/bin/sh

if pacmd list-sources | grep "\* index:" -A 11 | grep "muted: no" > /dev/null; then
    pacmd list-sources | grep "\* index:" -A 7 | grep volume | awk -F/ '{print $2}' | tr -d ' '
else
    echo "muted"
fi
