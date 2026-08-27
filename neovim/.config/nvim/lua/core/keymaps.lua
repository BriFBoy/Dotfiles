-- Quick keys
vim.keymap.set("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Write all buffers" })

-- Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Terminal mode escape
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
