return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Only start rubocop LSP when the project has a .rubocop.yml
        rubocop = {
          root_dir = require("lspconfig.util").root_pattern(".rubocop.yml"),
        },
      },
    },
  },
}