return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

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
