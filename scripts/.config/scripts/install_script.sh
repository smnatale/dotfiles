#!/bin/bash

# update and upgrade packages
sudo apt -y update
sudo apt -y upgrade

# install packages
sudo apt -y install i3 kitty rofi thunar i3blocks wireless-tools picom stow nitrogen neovim zsh ripgrep | exit

# set zsh as default not bash
chsh -s $(which zsh)

# install fzf from source
mkdir -p $HOME/.fzf
cd $HOME/.fzf
git clone git@github.com:junegunn/fzf.git
mv $HOME/.fzf/fzf/* $HOME/.fzf
chmod +x install
./install
