-- Driver for the whole JavaScript/TypeScript family: tsc + biome serve
-- all four filetypes, so all of them load this module (Lua's module cache
-- guarantees it runs once per session).

local mason = require("core.mason")
local dap = require("core.dap")

local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

mason.ensure("tsc")
mason.ensure("biome")
mason.ensure("js-debug-adapter")

-- biome-check = format + organize imports + safe lint fixes on save.
for _, ft in ipairs(filetypes) do
	require("core.format").register(ft, "biome-check")
end

-- Biome LSP for live diagnostics + quick-fix code actions; tsc keeps
-- completion/navigation. lspconfig's default only attaches when a biome.json
-- exists, so root_dir is overridden to lint every project.
vim.lsp.config("biome", {
	filetypes = filetypes,
	workspace_required = false,
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, { "biome.json", "biome.jsonc", "package.json", ".git" }) or vim.fn.getcwd())
	end,
})
vim.lsp.enable("biome")

-- tsc = TypeScript 7's native language server. lspconfig uses the project's
-- node_modules/.bin/tsc when it's 7+, else the Mason one on PATH.
vim.lsp.enable("tsc")

-- DAP: Node only — browser code is debugged with `debugger;` in DevTools
-- (Vite serves source maps). nvim-dap looks up the adapter by the launch
-- config's `type`, so it's registered as pwa-node.
local adapter = {
	type = "server",
	port = "${port}",
	executable = {
		command = "js-debug-adapter",
		args = { "${port}" },
	},
}

local configurations = {
	{
		type = "pwa-node",
		name = "Launch Node.js",
		request = "launch",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		console = "internalConsole",
	},
}

for _, ft in ipairs(filetypes) do
	dap.register(ft, {
		adapters = { ["pwa-node"] = adapter },
		configurations = configurations,
	})
end
