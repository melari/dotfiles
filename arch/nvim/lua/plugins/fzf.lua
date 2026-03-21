return {
  "junegunn/fzf.vim",
  dependencies = {
    "junegunn/fzf",
    run = function()
      vim.fn["fzf#install"]()
    end,
  },
  lazy = false,
  config = function()
    vim.api.nvim_set_keymap("n", "<c-f>", ":Rg<CR>", { noremap = true, silent = true })
  end,
}
