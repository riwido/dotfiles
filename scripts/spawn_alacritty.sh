#!/usr/bin/bash
# adapted from https://github.com/alacritty/alacritty/issues/808

print_working_dir () {
    active_window=$(xprop -root _NET_ACTIVE_WINDOW | grep -oP '0x\S+')

    active_wm_class=$(xprop -id $active_window | grep WM_CLASS)
    [[ $active_wm_class =~ "Alacritty" ]] || return

    pid=$(xprop -id $active_window | grep -oP "_NET_WM_PID.*?\K\d+")
    [[ -n $pid ]] || return

    cpid=$(pgrep -P $pid)
    [[ -n $cpid ]] || return

    cd "/proc/${cpid}/cwd"
    pwd -P
    cd - > /dev/null
    }

cwd=$(print_working_dir)

if [[ -n $cwd ]]; then
    alacritty --working-directory "$cwd"
else
    alacritty
fi
