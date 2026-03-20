local map = vim.keymap.set

-- === Normal mode mappings ===

map("n", "`", "<leader>e", { desc = "Open directory browser" })
map("n", "<C-p>", "<leader><space>", { desc = "Open fuzzy finder" })

map("n", "<C-l>", function()
  vim.cmd("vsplit")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader><space>", true, false, true), "n", false)
end, { desc = "Fuzzy finder in vertical split" })

map("n", "<C-k>", function()
  vim.cmd("new")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader><space>", true, false, true), "n", false)
end, { desc = "Fuzzy finder in horizontal split" })

map("n", "q:", ":q<cr>", { desc = "Fix common typo for :q" })
map("n", "K", "Vk", { desc = "Fix accidental K" })
map("n", "J", "Vj", { desc = "Fix accidental J" })

map("n", "<leader><leader>", "<cmd>nohlsearch<cr>:set nopaste<cr>:redraw!<cr>", { desc = "Reset search/paste mode" })

map("n", "<Left>", "<C-w><", { desc = "Decrease window width" })
map("n", "<Right>", "<C-w>>", { desc = "Increase window width" })
map("n", "<Up>", "<C-w>-", { desc = "Increase window height" })
map("n", "<Down>", "<C-w>+", { desc = "Decrease window height" })

-- === Visual mode mappings ===
map("v", ".", ":norm .<cr>", { desc = "Execute last command over selection" })
map("v", "<leader>#", ":norm I#<cr>", { desc = "Comment selected lines" })
map("v", "<leader>3", ":norm x<cr>", { desc = "Uncomment selected lines" })

-- === Copy current file name to clipboard ===
map("n", "tt", function()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then
    print("No file to copy")
    return
  end

  -- Try to get the Git root
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local base_dir = vim.fn.empty(git_root) == 0 and git_root or vim.fn.getcwd()

  -- Make path relative to base_dir
  local relpath = filepath:sub(#base_dir + 2) -- remove base_dir + "/"
  vim.fn.setreg("+", relpath)
  print("Copied relative path: " .. relpath)
end, { desc = "Copy file path relative to Git root or cwd" })
