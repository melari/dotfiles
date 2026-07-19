#!/usr/bin/env fish

# Fish setup required to ensure ~/.local/bin is available
./fish.fish; or exit $status

lib/safelink.fish ../dotfiles.fish ~/.local/bin/dot
