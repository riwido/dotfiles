#!/usr/bin/env bash

mkdir -p ~/.config
mkdir -p ~/.vim

ln -sf $PWD/nvim ~/.config/nvim
ln -sf $PWD/alacritty.toml ~/.config/alacritty.toml
ln -sf $PWD/i3 ~/.config/
ln -sf $PWD/i3status ~/.config/
ln -sf $PWD/pdm ~/.config/
ln -sf $PWD/.bash_logout ~/.bash_logout
ln -sf $PWD/.bashrc ~/.bashrc
ln -sf $PWD/.bash_profile ~/.bash_profile
ln -sf $PWD/.Xresources ~/.Xresources
ln -sf $PWD/.xinitrc ~/.xinitrc
ln -sf $PWD/coc-settings.json ~/.vim/coc-settings.json
ln -sf $PWD/.vimrc ~/.vimrc
ln -sf $PWD/.gitconfig ~/.gitconfig
