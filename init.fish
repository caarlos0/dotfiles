#!/bin/bash
# bins
mkdir -p ~/.bin
ln -sf $PWD/bin/* ~/.bin/

# tmux
mkdir -p ~/.config/tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
ln -sf $PWD/tmux.conf ~/.config/tmux/tmux.conf

# shell
mkdir -p ~/.config/fish/themes
fisher install jorgebucaran/hydro
ln -sf $PWD/fish/* ~/.config/fish/

# terms
mkdir -p ~/.config/ghostty
ln -sf $PWD/ghostty.config ~/.config/ghostty/config

# ssh 
mkdir -p ~/.ssh
ln -sf $PWD/ssh/* ~/.ssh/

# apps
mkdir -p ~/.hammerspoon
ln -sf $PWD/hammerspoon.lua /Users/carlos/.hammerspoon/init.lua
ln -sf $PWD/nvim ~/.config/nvim
ln -sf $PWD/gitconfig ~/.config/git/config
