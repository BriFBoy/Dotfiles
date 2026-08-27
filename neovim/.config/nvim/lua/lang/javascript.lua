-- Driver for the whole JavaScript/TypeScript family: one ts_ls server serves
-- all four filetypes, so all of them load this module (Lua's module cache
-- guarantees it runs once per session).

local mason = require("core.mason")
local dap = require("core.dap")
local ABORT = require("dap").ABORT

local filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

mason.ensure("typescript-language-server")
mason.ensure("biome")
mason.ensure("js-debug-adapter")

for _, ft in ipairs(filetypes) do
	require("core.format").register(ft, "biome")
	require("core.lint").register(ft, "biomejs")
end

vim.lsp.config("ts_ls", {
	settings = {
		completion = {
			completeFunctionCalls = true,
		},
	},
})
vim.lsp.enable("ts_ls")

-- DAP: the js-debug DAP server picks the target from the launch config's
-- `type` (pwa-node / pwa-chrome) and nvim-dap looks up the adapter by the
-- same field, so the one adapter is registered under both keys.
local adapter = {
	type = "server",
	port = "${port}",
	executable = {
		command = "js-debug-adapter",
		args = { "${port}" },
	},
}

--- Dev server URL (CRA/Next.js default), overridable on each run.
local function dev_server_url()
	local url = vim.fn.input("Dev server URL: ", "http://localhost:3000")
	return url ~= "" and url or ABORT
end

local configurations = {
	{
		type = "pwa-node",
		name = "Launch Node.js",
		request = "launch",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		console = "internalConsole",
	},
	{
		type = "pwa-chrome",
		name = "Launch web app (Chrome)",
		request = "launch",
		url = dev_server_url,
		webRoot = vim.fn.getcwd(),
	},
}

for _, ft in ipairs(filetypes) do
	dap.register(ft, {
		adapters = { ["pwa-node"] = adapter, ["pwa-chrome"] = adapter },
		configurations = configurations,
	})
end
