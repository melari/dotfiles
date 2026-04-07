-- Workaround for https://github.com/anthropics/claude-code/issues/20436
-- Claude Code garbles output in neovim terminals due to missing mode 2026 support.
-- Running inside tmux resolves this
return {
  "coder/claudecode.nvim",
  opts = {
    terminal_cmd = vim.fn.stdpath("config") .. "/scripts/claude-tmux",
  },
}
