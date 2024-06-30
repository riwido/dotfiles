#!/usr/bin/env bash

while read -r line
do
    WINDOW_ID="$(echo $line | grep -oP '0x[0-9a-f]+')"
    #WINDOW_NAME="$(xprop -id $WINDOW_ID | grep -oP '_NET_WM_NAME.*?"\K[^"]*')"

    #how to get same info separate from this
    #WINDOW_ID=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')

    WINDOW_CLASS="$(xprop -id $WINDOW_ID | grep -oP 'WM_CLASS.*?, "\K[^"]*')"
    WINDOW_PID="$(xprop -id $WINDOW_ID | grep -oP '_NET_WM_PID.*= \K\d+')"
    custom="${WINDOW_CLASS}"
    if [[ $WINDOW_CLASS == "firefox" ]]; then
        profile=$(grep -oP "${WINDOW_PID}=\K.*" $ff_pidfile)
        custom="firefox@${profile}"
    fi
    echo $custom > $active_class
    killall -USR1 i3status
done < <(xprop -spy -root _NET_ACTIVE_WINDOW)
