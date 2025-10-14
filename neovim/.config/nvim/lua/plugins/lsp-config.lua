return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "jdtls", "ts_ls", "cssls" },
			automatic_enable = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilites = require("blink.cmp").get_lsp_capabilities()
			vim.lsp.config("*", { capabilites = capabilites })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
			})
		end,
	},
}
