vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('n', '<leader>qq', ':qa<CR>', { desc = 'Quit all' })
vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Write all buffers" })
