return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end

		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Debugger continue" })
		vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Debugger Ui Toggle" })

		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = "/home/brian/.local/share/nvim/mason/packages/codelldb/codelldb",
				args = { "--port", "${port}" },
			},
		}
		dap.adapters["pwa-node"] = {
			type = "executable",
			command = "/home/brian/.local/share/nvim/mason/packages/js-debug-adapter/js-debug-adapter",
			args = { "--stdio" },
		}

		for _, language in ipairs({ "typescript", "javascript" }) do
			dap.configurations[language] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "node",
				},
			}
		end

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
				args = {}, -- you can add program args here
			},
		}
	end,
}
