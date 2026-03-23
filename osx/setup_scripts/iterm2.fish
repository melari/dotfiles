#!/usr/bin/env fish

brew install --cask font-jetbrains-mono-nerd-font

if not test -d /Applications/iTerm.app
    brew install --cask iterm2; or exit $status
end

mkdir -p ~/Library/Application\ Support/iTerm2/DynamicProfiles
lib/safelink.fish iterm2/Dotfiles.json ~/Library/Application\ Support/iTerm2/DynamicProfiles/Dotfiles.json true

if test $status -eq 0
    echo "⚠️ Create a new iterm2 profile called Dotfiles. You need to manually change your default profile to this one. Press any key to continue."
    read -n 1
end
