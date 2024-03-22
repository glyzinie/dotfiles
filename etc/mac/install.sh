#!/usr/bin/env zsh

# Command Line Tools for Xcode インストール
sudo xcode-select --install

# Rosetta2 インストール
#sudo softwareupdate --install-rosetta --agree-to-license

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle

# ⌘英かな (arm)
open https://github.com/yuyan7/cmd-eikana/releases/download/v2.2.3-arm/app.zip

# --- --- --- ---

# ネットワークドライブで.DS_Store を作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# USBドライブで.DS_Store を作成しない
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
killall Finder

# スクリーンショットの保存先を ~/Pictures/SS に変更
mkdir -p ~/Pictures/SS
defaults write com.apple.screencapture location ~/Pictures/SS
# スクリーンショットのファイル名からスクリーンショットを削除
defaults write com.apple.screencapture name ""
# スクリーンショットの保存形式を png に変更
defaults write com.apple.screencapture type png
# スクリーンショットに影を含めない
defaults write com.apple.screencapture disable-shadow -bool true
killall SystemUIServer

# LaunchPad 初期化
defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock

# .DS_Store を削除
find ~ -name '.DS_Store' -type f -ls -delete
