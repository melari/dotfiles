#!/usr/bin/env fish

# Usage: safelink.fish <source> <target> <exists-is-error>
# For convienence <source> is relative to the dotfiles directory.
# If the <target> already exists, a backup is created and the user is notified.
# If <exists-is-error> is true, Exit 2 is possible as per-below. If false (or excluded), the script is idempotent and will Exit 0 if the link already exists.
# Exit 0 = Created the symlink
# Exit 1 = Error
# Exit 2 = Symlink already existed

if test (count $argv) -lt 2
  echo "❌ Usage: $status: safelink.fish <source> <target>"
  exit 1
end

set script_dir (dirname (status -f))
set source (realpath $script_dir/../../$argv[1])
set target $argv[2]

if test -e $target; and not test -L $target
  mv $target $target.backup
  echo "⚠️ $target is being overwritten! A backup is available at $target.backup"
end

if test -e $target
  if test "$argv[3]" = "true"
    exit 2
  else
    exit 0
  end
else
  ln -s $source $target
  echo "🔗 Symlinked $target"
end
