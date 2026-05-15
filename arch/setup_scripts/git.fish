#!/usr/bin/env fish

# We assume that git is already installed because how else would you have this dotfiles repo?
# Here we just configure it a bit.

git config --global core.editor "vim"
git config --global merge.conflictstyle zdiff3
