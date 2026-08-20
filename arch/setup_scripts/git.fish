#!/usr/bin/env fish

# We assume that git is already installed because how else would you have this dotfiles repo?
# Here we just configure it a bit.

git config --global core.editor "vim"
git config --global merge.conflictstyle zdiff3
git config --global user.email "caleb@simpson.center"
git config --global user.name "Caleb"
