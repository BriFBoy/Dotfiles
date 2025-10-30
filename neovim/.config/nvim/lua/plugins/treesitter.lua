return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	opts = {
		ensure_installed = { "lua", "javascript", "java", "bash" },
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
		autotag = { enable = true },
	},
}
