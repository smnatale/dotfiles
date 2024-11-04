#!/bin/bash

echo "Updating and upgrading packages"
sudo apt -y update
sudo apt -y upgrade

echo "Installing packages..."
sudo apt -y install i3 kitty rofi thunar i3blocks wireless-tools picom stow nitrogen neovim zsh ripgrep tmux imagemagick snapd openjdk-11-jdk | exit

echo "Installing tmux package manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

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

echo "Cloning dotfiles..."
cd $HOME
git clone git@github.com:samnatale3/dotfiles.git

echo "Stowing dotfiles..."
stow dunst i3 i3blocks kitty nvim picom rofi scripts zsh

echo "Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

echo "Installing android studio..."
sudo add-apt-repository ppa:maarten-fonville/android-studio
sudo apt -y update
sudo apt -y install android-studio ia32-libs

