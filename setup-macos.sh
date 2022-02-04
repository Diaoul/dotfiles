#!/bin/bash
# install packages
brew bundle install

# setup fish
fish ~/.config/fish/setup.fish

# import public key
gpg --recv-keys 86170CE5CB464ADDC6BE8E597450F180356132B6

# configure gpg-agent
launchctl load -F ~/Library/LaunchAgents/homebrew.gpg.gpg-agent.plist
launchctl load -F ~/Library/LaunchAgents/link-ssh-auth-sock.plist

# always show hidden files
defaults write com.apple.finder AppleShowAllFiles True; killall Finder
