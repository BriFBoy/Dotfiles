return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	opts = {
		ensure_installed = { "lua", "javascript", "java", "bash", "rust", "c", "typescript" },
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
		autotag = { enable = true },
	},
}
