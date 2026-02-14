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
	keys = {
		{ "<leader>re", ":Refactor extract<CR>", mode = "x", desc = "Refactor Extract" },
		{ "<leader>rf", ":Refactor extract_to_file<CR>", mode = "x", desc = "Refactor Extract to File" },
		{ "<leader>rv", ":Refactor extract_var<CR>", mode = "x", desc = "Refactor Extract Variable" },

		{ "<leader>ri", ":Refactor inline_var<CR>", mode = { "n", "x" }, desc = "Refactor Inline Variable" },
		{ "<leader>rI", ":Refactor inline_func<CR>", desc = "Refactor Inline Function" },

		{ "<leader>rb", ":Refactor extract_block<CR>", desc = "Refactor Extract Block" },
		{ "<leader>rbf", ":Refactor extract_block_to_file<CR>", desc = "Refactor Extract Block to File" },
	},
}
