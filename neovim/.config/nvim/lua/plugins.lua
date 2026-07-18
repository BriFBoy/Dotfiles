local urls = require("utils.urls")

vim.pack.add({
	{ src = urls.gh("RedsXDD/neopywal.nvim") },
	{ src = urls.gh("romus204/tree-sitter-manager.nvim"), name = "tree-sitter-manager" },
	{ src = urls.gh("folke/snacks.nvim"), name = "snacks" },
	{ src = urls.gh("nvim-tree/nvim-web-devicons") },
	{ src = urls.gh("lewis6991/gitsigns.nvim") },
	{ src = urls.gh("nvim-lualine/lualine.nvim") },
	{ src = urls.gh("mason-org/mason.nvim") },
	-- autopairs
	{ src = urls.gh("windwp/nvim-autopairs") },
	{ src = urls.gh("windwp/nvim-ts-autotag") },
	-- Lsp
	{ src = urls.gh("neovim/nvim-lspconfig") },
	-- Formatting and linting
	{ src = urls.gh("stevearc/conform.nvim") },
	-- Autocompletion
	{ src = urls.gh("saghen/blink.cmp"), version = vim.version.range(">=1.10") },
	{ src = urls.gh("rafamadriz/friendly-snippets") },
	-- Debugging
	urls.gh("mfussenegger/nvim-dap"),
	-- languages
	{
		src = urls.gh("mrcjkb/rustaceanvim"),
		version = vim.version.range("^9"),
	},
	urls.gh("nvim-java/nvim-java"),
	{
		src = urls.gh("JavaHello/spring-boot.nvim"),
		version = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
	},
	urls.gh("MunifTanjim/nui.nvim"),
	{ src = urls.gh("seblj/roslyn.nvim"), name = "roslyn" },
})
