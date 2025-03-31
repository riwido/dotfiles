#!/bin/bash


clipboard_count () {
    xcontent=$(xclip -o 2> /dev/null)
    xlines=$(printf "%s" "$xcontent" | wc -l)
    xchars=$(printf "%s" "$xcontent" | wc -m)

    content=$(xclip -selection clipboard -o 2> /dev/null)
    lines=$(printf "%s" "$content" | wc -l)
    chars=$(printf "%s" "$content" | wc -m)

    printf "%d %d | %d %d" $xlines $xchars $lines $chars
    }


# config relies on some environment variables
i3status -c <(envsubst < $HOME/.config/i3status/config) | while :
do
    read -r line
    output="$(clipboard_count) | ${line}";
    echo "${output}" || exit 1
done
