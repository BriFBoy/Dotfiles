local s = require("snacks")
s.setup({
	explorer = { enabled = true },
	indent = { enabled = true },
	picker = { enabled = true },
})
-- Top Pickers & Explorer
vim.keymap.set("n", "<leader>:", function() s.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>n", function() s.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>e", function() s.explorer() end, { desc = "File Explorer" })

-- Find
vim.keymap.set("n", "<leader>fb", function() s.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fg", function() s.picker.grep() end, { desc = "Find Grep" })
vim.keymap.set("n", "<leader>ff", function() s.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fp", function() s.picker.projects() end, { desc = "Projects" })
vim.keymap.set("n", "<leader>fr", function() s.picker.recent() end, { desc = "Recent" })
