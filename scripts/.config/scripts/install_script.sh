#!/bin/bash

echo "Updating and upgrading packages"
sudo apt -y update
sudo apt -y upgrade

echo "Installing packages..."
sudo apt -y install i3 kitty rofi thunar i3blocks wireless-tools picom stow nitrogen neovim zsh ripgrep | exit

echo "Setting default shell to zsh..."
chsh -s $(which zsh)

echo "Installing fzf from source..."
mkdir -p $HOME/.fzf
cd $HOME/.fzf
git clone git@github.com:junegunn/fzf.git
mv $HOME/.fzf/fzf/* $HOME/.fzf
chmod +x install
./install

echo "Setting nvim as default git editor..."
git config --global core.editor "nvim"

echo "Cloning dotfiles"
cd $HOME
git clone git@github.com:samnatale3/dotfiles.git

echo "Stowing dotfiles"
stow dunst i3 i3blocks kitty nvim picom rofi scripts zsh
