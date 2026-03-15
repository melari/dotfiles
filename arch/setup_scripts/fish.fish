#!/usr/bin/env fish

mkdir -p ~/.config/fish
mkdir -p ~/.local/bin

# Called with exists-is-error=true so that we only print the
# message to re-source the config if the symlink was actively created
lib/safelink.fish fish/config.fish ~/.config/fish/config.fish true

if test $status -eq 0
  echo "🚩 Run `source ~/.config/fish/config.fish` then retry"
  exit 1
end
