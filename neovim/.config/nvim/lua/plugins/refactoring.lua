return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = false,
	opts = {
		prompt_func_param_type = {
			java = true,
			cpp = true,
			c = true,
		},
		printf_statements = {},
		print_var_statements = {},
		show_success_message = true, -- shows a message with information about the refactor on success
		-- i.e. [Refactor] Inlined 3 variable occurrences
	},
	config = function()
		vim.keymap.set("x", "<leader>re", ":Refactor extract ")
		vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")

		vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")

		vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

		vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

		vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
		vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
	end,
}
