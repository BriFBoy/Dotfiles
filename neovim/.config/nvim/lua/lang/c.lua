-- C/C++: clangd (LSP + clang-tidy) + clang-format + codelldb.

local mason = require("core.mason")
local dap = require("core.dap")
local ABORT = require("dap").ABORT

mason.ensure("clangd")
mason.ensure("clang-format")

for _, ft in ipairs({ "c", "cpp" }) do
	require("core.format").register(ft, "clang-format")
end

-- clang-tidy runs inside clangd, so no separate nvim-lint registration
vim.lsp.config("clangd", {
	cmd = { "clangd", "--clang-tidy", "--background-index" },
})
vim.lsp.enable("clangd")

--- Executable regular files in build/ and the cwd, newest first.
local function executables()
	local cwd = vim.fn.getcwd()
	local out = {}
	for _, dir in ipairs({ cwd .. "/build", cwd }) do
		for _, f in ipairs(vim.fn.glob(dir .. "/*", false, true)) do
			if vim.fn.isdirectory(f) == 0 and vim.fn.executable(f) == 1 then
				out[#out + 1] = f
			end
		end
	end
	return dap.sort_newest(out)
end

--- Executable to debug (most recent by default), falling back to a path prompt.
local function resolve_program()
	local bins = executables()
	if #bins == 0 then
		return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
	end

	local bin = dap.pick(bins, "Debug executable: ")
	if not bin then
		return ABORT
	end

	return vim.fn.input("Executable to debug: ", bin, "file")
end

-- Same codelldb adapter as lang/rust.lua; re-registering just overwrites dap.adapters.codelldb.
for _, ft in ipairs({ "c", "cpp" }) do
	dap.register(ft, {
		mason = "codelldb",
		name = "codelldb",
		adapter = {
			type = "server",
			port = "${port}",
			executable = {
				command = "codelldb",
				args = { "--port", "${port}" },
			},
		},
		configurations = {
			{
				type = "codelldb",
				name = "Debug executable",
				request = "launch",
				program = resolve_program,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		},
	})
end
