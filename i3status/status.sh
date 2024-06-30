#!/bin/bash

# config relies on some environment variables
i3status -c <(envsubst < $HOME/.config/i3status/config) | while :
do
    read line
    # custom info not needed, but this is how it's done
    # output="$(custom) | ${line}";
    output=$line
    echo "${output}" || exit 1
done
