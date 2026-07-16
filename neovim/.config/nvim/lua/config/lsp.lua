vim.lsp.config["lua_ls"] = {
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					"vim",
				},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
vim.lsp.config("jedi-language-server", {
	cmd = { "jedi-language-server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
})
vim.lsp.config("html", {
	filetypes = { "html", "rust" },
	init_options = {
		configurationSection = { "html", "css", "javascript", "rust" },
		embeddedLanguages = {
			css = true,
			javascript = true,
			rust = true,
		},
		provideFormatter = true,
	},
})

vim.lsp.enable("html")
vim.lsp.enable("css")
