local fzf_lua = require("fzf-lua")
fzf_lua.setup({
	-- Route vim.ui.select through fzf, so plugins that use it for prompts
	-- (e.g. nvim-dap's "Session active, but not stopped at breakpoint" menu)
	-- get the fzf UI instead of the built-in numbered menu.
	ui_select = {},
})

-- fzf-lua Keymaps
vim.keymap.set("n", "ff", fzf_lua.files, { desc = "Find files" })

local oil = require("oil")
oil.setup({
	keymaps = {
		h = { "actions.parent", mode = "n" },
		["l"] = "actions.select",
	},
})

vim.keymap.set("n", "<leader>ee", oil.open, { desc = "Open File Explorer" })
