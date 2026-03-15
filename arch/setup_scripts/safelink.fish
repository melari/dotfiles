#!/usr/bin/env fish

# Usage: safelink.fish <source> <target>
# For convienence <source> is relative to the dotfiles directory.
# If the <target> already exists, a backup is created and the user is notified.
# Exit 0 = Created the symlink
# Exit 1 = Error
# Exit 2 = Symlink already existed

if test (count $argv) -ne 2
  echo "❌ Usage: $status: safelink.fish <source> <target>"
  exit 1
end

set script_dir (dirname (status -f))
set source (realpath $script_dir/../$argv[1])
set target $argv[2]

if test -e $target; and not test -L $target
  mv $target $target.backup
  echo "⚠️ $target is being overwritten! A backup is available at $target.backup"
end

if test -e $target
  exit 2
else
  ln -s $source $target
end
