return {
	lua = {
		lsp = "lua-language-server",
		lsp_name = "lua_ls",
		formatter = "stylua",
	},
	c = {
		lsp = "clangd",
		lsp_name = "clangd",
		formatter = "clang-format",
	},
	rust = {
		formatter = "rustfmt",
	},
	java = {
		lsp = "jdtls",
		lsp_name = "jdtls",
		formatter = nil,
	},
	javascript = {
		lsp = "typescript-language-server",
		lsp_name = "ts_ls",
		formatter = "prettier",
	},
	csharp = {
		lsp = "roslyn",
		lsp_name = "roslyn",
		formatter = "csharpier",
	},
	python = {
		lsp = "jedi-language-server",
		lsp_name = "jedi-language-server",
		formatter = "black",
	},
	-- You will need to install these manualy with:
	-- npm i -g vscode-langservers-extracted
	html = {
		lsp_name = "html",
	},
	css = {
		lsp_name = "cssls",
	},
}
