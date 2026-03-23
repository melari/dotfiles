#!/usr/bin/env fish

./iterm2.fish; or exit $status

# treesitter requires a c compiler
if ! xcode-select -p &>/dev/null; then
  xcode-select --install; or exit $status
end

brew install neovim tree-sitter fzf ripgrep fd; or exit $status

lib/safelink.fish ../arch/nvim ~/.config/nvim; or exit $status
