#!/usr/bin/env bash

mkdir -p ~/.config/i3
mkdir -p ~/.vim

ln -s $PWD/i3 ~/.config/
ln -sf $PWD/.bash_logout ~/.bash_logout
ln -sf $PWD/.bashrc ~/.bashrc
ln -sf $PWD/.bash_profile ~/.bash_profile
ln -s $PWD/.Xresources ~/.Xresources
ln -s $PWD/.xinitrc ~/.xinitrc
ln -s $PWD/coc-settings.json ~/.vim/coc-settings.json
ln -s $PWD/.vimrc ~/.vimrc
