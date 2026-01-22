return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			automatic_enable = {
				ensure_installed = {
					"lua_ls",
					"jdtls",
					"clangd",

					-- Javascript/Typescript + css
					"eslint",
					"cssls",
					"tailwindcss",
				},
				exclude = {
					"jdtls",
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

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
