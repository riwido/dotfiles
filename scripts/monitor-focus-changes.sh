#!/usr/bin/env bash

while read -r line
do
    #WINDOW_ID="$(echo $line | grep -oP '0x[0-9a-f]+')"
    #WINDOW_NAME="$(xprop -id $WINDOW_ID | grep -oP '_NET_WM_NAME.*?"\K[^"]*')"
    killall -USR1 i3status
done < <(xprop -spy -root _NET_ACTIVE_WINDOW)
