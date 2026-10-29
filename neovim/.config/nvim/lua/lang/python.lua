-- Python: ruff (lint/format) + basedpyright (types) + debugpy.

local mason = require("core.mason")

mason.ensure("ruff")
mason.ensure("basedpyright")

require("core.format").register("python", { "ruff_organize_imports", "ruff_format" })

-- ruff is the linter/formatter; its lint diagnostics come through the LSP, so no
-- separate nvim-lint registration (that would double every finding).
-- Hover is left to basedpyright (per ruff docs).
vim.lsp.config("ruff", {
	on_attach = function(client)
		client.server_capabilities.hoverProvider = false
	end,
})
vim.lsp.enable("ruff")

-- basedpyright handles types/navigation; ruff owns import sorting
vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = { typeCheckingMode = "standard" },
		},
	},
})
vim.lsp.enable("basedpyright")

--- Active virtualenv, then ./.venv, then system python3.
local function python_path()
	local venv = os.getenv("VIRTUAL_ENV")
	if venv and vim.fn.executable(venv .. "/bin/python") == 1 then
		return venv .. "/bin/python"
	end
	local local_venv = vim.fn.getcwd() .. "/.venv/bin/python"
	if vim.fn.executable(local_venv) == 1 then
		return local_venv
	end
	return "python3"
end

require("core.dap").register("python", {
	mason = "debugpy",
	name = "python",
	adapter = { type = "executable", command = "debugpy-adapter" },
	configurations = {
		{
			type = "python",
			name = "Debug current file",
			request = "launch",
			program = "${file}",
			cwd = "${workspaceFolder}",
			pythonPath = python_path,
		},
	},
})
