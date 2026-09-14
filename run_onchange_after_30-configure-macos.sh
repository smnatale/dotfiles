#!/bin/sh

set -eu

/usr/bin/defaults write NSGlobalDomain AppleInterfaceStyle -string Dark
/usr/bin/defaults write NSGlobalDomain KeyRepeat -int 2
/usr/bin/defaults write NSGlobalDomain InitialKeyRepeat -int 30
/usr/bin/defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
/usr/bin/defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
/usr/bin/defaults write NSGlobalDomain _HIHideMenuBar -bool true
/usr/bin/defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -bool false

/usr/bin/defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
/usr/bin/defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
/usr/bin/defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
/usr/bin/defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
/usr/bin/defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true
/usr/bin/defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

/usr/bin/defaults write com.apple.spaces spans-displays -bool true

/usr/bin/defaults write com.apple.dock autohide -bool true
/usr/bin/defaults write com.apple.dock tilesize -int 44
/usr/bin/defaults write com.apple.dock mru-spaces -bool false
/usr/bin/defaults write com.apple.dock show-recents -bool false

/usr/bin/killall Dock >/dev/null 2>&1 || true
/usr/bin/killall Finder >/dev/null 2>&1 || true
/usr/bin/killall SystemUIServer >/dev/null 2>&1 || true
