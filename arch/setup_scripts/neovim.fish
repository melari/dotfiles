#!/usr/bin/env fish

./yay.fish; or exit $status
./kitty.fish; or exit $status

sudo pacman -S --needed --noconfirm tmux; or exit $status
yay -S --needed --noconfirm wl-clipboard neovim-git tree-sitter-cli base-devel curl fzf ripgrep fd; or exit $status

lib/safelink.fish nvim ~/.config/nvim; or exit $status
