local dap = require("dap")

-- C / C++
dap.configurations.c = {
	{
		name = "Launch C program",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
}
dap.configurations.cpp = dap.configurations.c

-- Other dap configurations
require("config.dap.js")
