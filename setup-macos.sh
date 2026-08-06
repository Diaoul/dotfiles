#!/bin/bash
set -euo pipefail

# ask for sudo upfront and keep it alive for the duration of the script
sudo -v
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# fetch anonymously over https, push over ssh
git --git-dir="$HOME/.dotfiles" remote set-url origin https://github.com/Diaoul/dotfiles.git
git --git-dir="$HOME/.dotfiles" remote set-url --push origin git@github.com:Diaoul/dotfiles.git

# install homebrew
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# trust third-party taps
brew tap felixkratz/formulae
brew tap nikitabobko/tap
brew trust felixkratz/formulae
brew trust nikitabobko/tap

# install packages
brew bundle install --file="$HOME/Brewfile"

# install the "Monospace" family alias (macOS has no fontconfig, so the shared
# terminal configs asking for "Monospace" need a real font by that name)
~/.local/bin/install-monospace-font-alias.py

# setup fish
fish ~/.config/fish/setup.fish

# make fish the login shell
FISH="$(brew --prefix)/bin/fish"
if ! grep -q "$FISH" /etc/shells; then
  echo "$FISH" | sudo tee -a /etc/shells
fi
if [ "$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}')" != "$FISH" ]; then
  chsh -s "$FISH"
fi

# import public key and trust it
chmod 700 ~/.gnupg
gpg --keyserver hkps://keys.openpgp.org --recv-keys 86170CE5CB464ADDC6BE8E597450F180356132B6
echo "86170CE5CB464ADDC6BE8E597450F180356132B6:6:" | gpg --import-ownertrust

# configure gpg-agent
launchctl bootout "gui/$(id -u)/homebrew.gpg.gpg-agent" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/homebrew.gpg.gpg-agent.plist
launchctl bootout "gui/$(id -u)/link-ssh-auth-sock" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/link-ssh-auth-sock.plist

# sudo with touch id
if [ ! -f /etc/pam.d/sudo_local ]; then
  sudo sed 's/^#auth/auth/' /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local >/dev/null
fi

# always show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# system-wide dark mode (applies at next login)
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# auto-hide the dock and the menu bar (sketchybar is the top bar)
defaults write com.apple.dock autohide -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# fast key repeat, no accented character popup
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# tap to click (built-in trackpad, Bluetooth trackpad, and the global flag the
# login window and non-trackpad-aware apps read)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# screenshots in their own folder
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots

# no .DS_Store on network shares
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# reverse scrolling for mice only (BetterTouchTool applies this once installed)
defaults write com.hegenberg.BetterTouchTool BTTReverseScrollingOnNormalMice -int 1

# don't reveal desktop when clicking the wallpaper (except in Stage Manager)
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

killall Finder || true
killall SystemUIServer || true
killall Dock || true

cat <<'EOF'

Done! Manual steps left.

Launch each app once so it triggers its permission prompts and registers
itself at login:
  - AeroSpace: grant Accessibility; starts at login via its config and
    launches sketchybar + borders itself
  - Hammerspoon: grant Accessibility; registers itself at login
    (hs.autoLaunch in init.lua) - needed for monitor plug/unplug layout
  - Karabiner-Elements: approve the driver extension in System Settings >
    Privacy & Security, grant Input Monitoring; its services then start at
    boot on their own
  - BetterTouchTool: install v5.554 manually first (folivora.ai archive) -
    newer versions need a new license; disable auto-update and enable
    "launch on startup" in its settings, grant Accessibility
  - Quill: no cask, download from quillmeetings.com; sign in and grant
    Microphone + Screen Recording
  - Raycast: import the .rayconfig export from the previous machine
    (Settings > Advanced > Import), grant Accessibility

Then:
  - Colemak DH layouts are installed (~/Library/Keyboard Layouts); to type
    with one on the built-in keyboard, add it in System Settings > Keyboard >
    Input Sources (needs a re-login to show up)
  - gh auth login
  - plug the Yubikey
EOF
