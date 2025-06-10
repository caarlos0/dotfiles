#!/bin/bash

# tmux
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
ln -sf $PWD/tmux.conf ~/.config/tmux/tmux.conf

# shell
mkdir -p ~/.config/fish/themes
fisher install jorgebucaran/hydro
ln -sf $PWD/gruvbox-dark.theme ~/.config/fish/themes/gruvbox.theme
ln -sf $PWD/config.fish ~/.config/fish/config.fish
ln -sf $PWD/functions/* ~/.config/fish/functions/
fish_add_path -a $PWD/bin

# terms
mkdir -p ~/.config/ghostty
ln -sf $PWD/ghostty.config ~/.config/ghostty/config

# apps
mkdir -p ~/.hammerspoon
ln -sf $PWD/hammerspoon.lua /Users/carlos/.hammerspoon/init.lua
ln -sf $PWD/nvim ~/.config/nvim
ln -sf $PWD/gitconfig ~/.config/git/config

ln -sf $PWD/bin/*
