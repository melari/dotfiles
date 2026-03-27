local map = vim.keymap.set

-- === Normal mode mappings ===

map("n", "`", "<leader>e", { remap = true, desc = "Open directory browser" })
map("n", "<C-p>", "<leader><space>", { remap = true, desc = "Open fuzzy finder" })
map("n", "<C-l>", "<leader>|<leader><space>", { remap = true, desc = "Open fuzzy finder in right split" })
map("n", "<C-k>", "<leader>-<leader><space>", { remap = true, desc = "Open fuzzy finder in horizontal split" })
map("n", "<C-j>", "<C-k>", { remap = true, desc = "Open fuzzy finder in horizontal split" })

map("n", "q:", ":q<cr>", { desc = "Fix common typo for :q" })
map("n", "K", "Vk", { desc = "Fix accidental K" })
map("n", "J", "Vj", { desc = "Fix accidental J" })

map("n", "<leader><leader>", "<cmd>nohlsearch<cr>:set nopaste<cr>:redraw!<cr>", { desc = "Reset search/paste mode" })

map("n", "<Left>", "<C-w><", { desc = "Decrease window width" })
map("n", "<Right>", "<C-w>>", { desc = "Increase window width" })
map("n", "<Up>", "<C-w>-", { desc = "Increase window height" })
map("n", "<Down>", "<C-w>+", { desc = "Decrease window height" })

-- Associated plugin definition: plugins/fzf.lua
map("n", "<C-f>", ":Rg<CR>", { remap = true, desc = "Open Ripgrep" })

-- === Visual mode mappings ===
map("v", ".", ":norm .<cr>", { desc = "Execute last command over selection" })
map("v", "<leader>#", ":norm I#<cr>", { desc = "Comment selected lines" })
map("v", "<leader>4", ":norm x<cr>", { desc = "Uncomment selected lines" })

-- Make sure pasting in visual mode doesn't replace the paste buffer
local _restore_reg = ""
_G._RestoreRegister = function()
  vim.fn.setreg('"', _restore_reg)
  return ""
end
map("v", "p", function()
  _restore_reg = vim.fn.getreg('"')
  return "p@=v:lua._RestoreRegister()\r"
end, { silent = true, expr = true, desc = "Paste without overwriting register" })

-- === Claude mappings ===
map("n", "<C-a>", "<leader>af", { remap = true, desc = "Open/focus Claude" })
map("n", "<C-y>", "<leader>aa", { remap = true, desc = "Accept Diff from Claude" })
map("n", "<C-n>", "<leader>ad", { remap = true, desc = "Reject Diff from Claude" })
map("n", "<C-s>", "<leader>ab", { remap = true, desc = "Send file to claude" })
map("v", "<C-s>", "<leader>as", { remap = true, desc = "Send selection to Claude" })

-- === Custom commands ===
vim.api.nvim_create_user_command("Gblame", "Gitsigns blame", { desc = "Git blame for current file" })

vim.api.nvim_create_user_command("Gbrowse", function(opts)
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local remote = vim.fn.systemlist("git remote get-url origin")[1]
  local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
  local filepath = vim.fn.expand("%:p")
  local relpath = filepath:sub(#git_root + 2)

  -- Convert git remote URL to https
  local url = remote:gsub("git@github%.com:", "https://github.com/"):gsub("%.git$", "")
  url = url .. "/blob/" .. branch .. "/" .. relpath

  -- Add line range
  if opts.range == 2 then
    url = url .. "#L" .. opts.line1 .. "-L" .. opts.line2
  else
    url = url .. "#L" .. vim.fn.line(".")
  end

  vim.fn.system({ "open", url })
end, { range = true, desc = "Open current file on GitHub" })

vim.api.nvim_create_user_command("Delete", function()
  local path = vim.fn.expand("%:p")
  if path == "" then
    vim.notify("No file to delete", vim.log.levels.WARN)
    return
  end
  vim.fn.delete(path)
  vim.cmd("bwipeout!")
end, { desc = "Delete current file and close buffer" })

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
