local mason = require("core.mason")
local dap = require("core.dap")

mason.ensure("rust-analyzer")
require("core.format").register("rust", "rustfmt")

--- Executables built directly under target/debug (skips directories and artifacts), newest first.
local function debug_binaries()
	local dir = vim.fn.getcwd() .. "/target/debug"
	local out = {}
	for _, f in ipairs(vim.fn.glob(dir .. "/*", false, true)) do
		if vim.fn.isdirectory(f) == 0 and vim.fn.fnamemodify(f, ":e") == "" then out[#out + 1] = f end
	end
	return dap.sort_newest(out)
end

--- Binary to debug (most recent by default), offering a `cargo build` if none exist yet.
local function resolve_binary()
	local bins = debug_binaries()

	if #bins == 0 then
		bins = dap.offer_build(
			"No built binary in target/debug.\nRun 'cargo build' now?",
			{ "cargo", "build" },
			debug_binaries
		) or bins
	end

	if #bins == 0 then
		vim.notify("no built binary in " .. vim.fn.getcwd() .. "/target/debug; run 'cargo build'", vim.log.levels.WARN)
		return nil
	end

	local bin = dap.pick(bins, "Debug binary: ")
	if not bin then return nil end

	return vim.fn.input("Binary to debug: ", bin, "file")
end

dap.register("rust", {
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
			name = "Debug Rust binary",
			request = "launch",
			program = resolve_binary,
			cwd = vim.fn.getcwd(),
			stopOnEntry = false,
		},
	},
})
