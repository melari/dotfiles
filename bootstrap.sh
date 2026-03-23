#!/usr/bin/env bash

script_dir=$(dirname "$0")

if ! command -v fish &>/dev/null; then
    os=$(uname)

    if [ "$os" = "Darwin" ]; then
        if ! command -v brew &>/dev/null; then
            NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install fish
    else
        sudo pacman -S --needed --noconfirm fish
    fi
fi

fish "$script_dir/dotfiles.fish"
