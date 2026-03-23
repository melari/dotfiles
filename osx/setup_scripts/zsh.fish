#!/usr/bin/env fish

lib/safelink.fish zsh/.zshrc ~/.zshrc true

if test $status -eq 0
  echo "🚩 Run `source ~/.zshrc` then retry"
  exit 1
end
