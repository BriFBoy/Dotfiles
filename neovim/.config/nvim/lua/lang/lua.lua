-- Lua: lua_ls (LSP) + stylua.

local mason = require("core.mason")

mason.ensure("lua-language-server")
mason.ensure("stylua")

require("core.format").register("lua", "stylua")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
})
vim.lsp.enable("lua_ls")
