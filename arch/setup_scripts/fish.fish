#!/usr/bin/env fish

mkdir -p ~/.config/fish
mkdir -p ~/.local/bin

./safelink.fish fish/config.fish ~/.config/fish/config.fish

if test $status -eq 0
  echo "🚩 Run `source ~/.config/fish/config.fish` then retry"
  exit 1
end
