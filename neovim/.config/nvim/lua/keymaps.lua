vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opts = { noremap = true, silent = true }
local function desc(description)
	return vim.tbl_extend("force", opts, { desc = description })
end

-- Quick keys
vim.keymap.set("n", "<leader>qq", ":qa<CR>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Write all buffers" })

-- Navigation
vim.keymap.set("n", "gd", vim.lsp.buf.definition, desc("Go to Definition"))
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, desc("Go to Implementation"))
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, desc("Go to Type Definition"))
vim.keymap.set("n", "gr", vim.lsp.buf.references, desc("Find References"))
vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, desc("Signature Help"))

-- Code actions & edits
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, desc("Rename Symbol"))
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, desc("Code actions"))

-- Modes
vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true })

vim.keymap.set("n", "K", vim.lsp.buf.hover, desc("Shows Hover Info"))

-- Remapping
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
