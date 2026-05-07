return {
	lua = {
		lsp = "lua-language-server",
		lsp_name = "lua_ls",
		formatter = "stylua",
		linter = "luacheck",
	},
	c = {
		lsp = "clangd",
		lsp_name = "clangd",
		formatter = "clang-format",
		linter = "cpplint",
	},
	rust = {
		formatter = "rustfmt",
	},
	java = {
		lsp = "jdtls",
		lsp_name = nil,
	},
	javascript = {
		lsp = "typescript-language-server",
		lsp_name = "ts_ls",
		formatter = "prettier",
		linter = "eslint_d",
	},
}
