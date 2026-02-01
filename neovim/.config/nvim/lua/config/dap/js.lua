local dap = require("dap")

-- Javascript / Typescript
local mason = vim.fn.stdpath("data") .. "/mason/packages"
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			mason .. "/js-debug-adapter/js-debug/src/dapDebugServer.js",
			"${port}",
		},
	},
}
for _, language in ipairs({ "javascript", "typescript" }) do
	dap.configurations[language] = {
		{
			name = "Launch JS/TS file",
			type = "pwa-node", -- ⭐ must match the adapter name above
			request = "launch",
			program = "${file}",
			cwd = "${workspaceFolder}",
			runtimeExecutable = "node",
			console = "integratedTerminal",
		},
	}
end
