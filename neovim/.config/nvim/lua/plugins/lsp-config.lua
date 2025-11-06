return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "jdtls", "ts_ls", "cssls", "tailwindcss" },
			automatic_enable = {
				exclude = {
					"jdtls",
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilites = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", { capabilites = capabilites })

			vim.diagnostic.config({
				virtual_text = {
					severity = {
						min = vim.diagnostic.severity.WARN,
						max = vim.diagnostic.severity.ERROR,
					},
				},
				signs = true,
				underline = true,
				update_in_insert = false,
			})
		end,
	},
}
