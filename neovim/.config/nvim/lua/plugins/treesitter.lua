return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "<filetype>" },
			callback = function() vim.treesitter.start() end,
		})
		require("nvim-treesitter").install({
			"rust",
			"javascript",
			"typescript",
			"zig",
			"c",
			"java",
		})
	end,
}
