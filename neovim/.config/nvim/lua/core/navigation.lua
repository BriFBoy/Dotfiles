local fzf_lua = require("fzf-lua")
fzf_lua.setup({
	ui_select = {},
})

-- fzf-lua Keymaps
vim.keymap.set("n", "ff", fzf_lua.files, { desc = "Find files" })
vim.keymap.set("n", "fg", fzf_lua.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fr", fzf_lua.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fh", fzf_lua.helptags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fc", fzf_lua.commands, { desc = "Commands" })

local oil = require("oil")
oil.setup({
	keymaps = {
		h = { "actions.parent", mode = "n" },
		["l"] = "actions.select",
	},
})

vim.keymap.set("n", "<leader>ee", oil.open, { desc = "Open File Explorer" })
