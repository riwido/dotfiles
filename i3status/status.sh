#!/bin/bash
i3status -c <(envsubst < $HOME/.config/i3status/config) | while :
do
    read line
    WINDOW_ID=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
    WINDOW_CLASS="$(xprop -id $WINDOW_ID | grep -oP 'WM_CLASS.*?, "\K[^"]*')"
    WINDOW_PID="$(xprop -id $WINDOW_ID | grep -oP '_NET_WM_PID.*= \K\d+')"
    custom="${WINDOW_CLASS}"
    if [[ $WINDOW_CLASS == "firefox" ]]; then
        profile=$(grep -oP "${WINDOW_PID}=\K.*" $ff_pidfile)
        custom="firefox@${profile}"
    fi
    echo "${custom} | ${line}" || exit 1
done
