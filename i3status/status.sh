#!/bin/bash


clipboard_count () {
    xcontent=$(xclip -o 2> /dev/null)
    xlines=$(printf -- "$xcontent" | wc -l)
    xchars=$(printf -- "$xcontent" | wc -c)

    content=$(xclip -selection clipboard -o 2> /dev/null)
    lines=$(printf -- "$content" | wc -l)
    chars=$(printf -- "$content" | wc -c)

    printf "%d %d | %d %d" $xlines $xchars $lines $chars
    }


# config relies on some environment variables
i3status -c <(envsubst < $HOME/.config/i3status/config) | while :
do
    read line
    output="$(clipboard_count) | ${line}";
    echo "${output}" || exit 1
done
