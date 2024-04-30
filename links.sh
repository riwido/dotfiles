#!/usr/bin/env bash

mkdir -p ~/.config/i3
mkdir -p ~/.vim

ln -s $PWD/i3/config ~/.config/i3/config
ln -s $PWD/.bash_logout ~/.bash_logout
ln -s $PWD/.bashrc ~/.bashrc
ln -s $PWD/.bash_profile ~/.bash_profile
ln -s $PWD/.Xresources ~/.Xresources
ln -s $PWD/.xinitrc ~/.xinitrc
ln -s $PWD/coc-settings.json ~/.vim/coc-settings.json
