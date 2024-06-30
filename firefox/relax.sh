#!/usr/bin/env bash

profiles=$HOME/.mozilla/firefox
profile=$1

usage (){
    echo "$0 <profile>"
}
if [[ $profile == "-h" ]]; then
    usage
    exit 0
fi

if [[ -z $profile ]]; then
    usage
    exit 1
fi

profile_path=$(find $profiles -maxdepth 1 -type d -name "*.${profile}")
if [[ -z $profile_path ]]; then
    echo "$profile doesn't exist"
    exit 1
fi

ln -sf $PWD/firefox-relaxed.cfg.js $profile_path/user.js
