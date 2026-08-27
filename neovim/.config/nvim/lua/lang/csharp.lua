local mason = require("core.mason")
local dap = require("core.dap")
local ABORT = require("dap").ABORT

mason.ensure("roslyn-language-server")
mason.ensure("csharpier")

require("core.format").register("cs", "csharpier")

require("roslyn").setup()

-- plugin/roslyn.lua already calls vim.lsp.enable("roslyn") at startup;
-- this only adds the server settings used at attach time
vim.lsp.config("roslyn", {
	settings = {
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
		},
	},
})

-- DAP: debug the project open in the current directory.

--- .csproj files in the cwd, or all of them below it (excluding build dirs).
local function project_candidates()
	local cwd = vim.fn.getcwd()
	local candidates = vim.fn.glob(cwd .. "/*.csproj", false, true)

	if #candidates == 0 then
		for _, p in ipairs(vim.fn.glob(cwd .. "/**/*.csproj", false, true)) do
			if not p:find("/obj/") and not p:find("/bin/") then candidates[#candidates + 1] = p end
		end
	end

	table.sort(candidates)
	return candidates
end

--- Output assembly name: <AssemblyName> if set, else the project file name.
local function assembly_name(proj)
	local src = table.concat(vim.fn.readfile(proj), "\n")
	local name = src:match("<AssemblyName>([^<]+)</AssemblyName>")
	if name and name ~= "" then return name end
	return vim.fn.fnamemodify(proj, ":t:r")
end

--- Most recently built output dll of a project, Debug preferred over Release.
local function latest_dll(proj)
	local dir = vim.fn.fnamemodify(proj, ":h")
	local matches = vim.fn.glob(dir .. "/bin/*/*/" .. assembly_name(proj) .. ".dll", false, true)

	table.sort(matches, function(a, b)
		local da, db = a:find("/Debug/") ~= nil, b:find("/Debug/") ~= nil
		if da ~= db then return da end
		return dap.mtime(a) > dap.mtime(b)
	end)

	return matches[1]
end

--- Latest dll of a project, offering a `dotnet build` if there is none.
local function resolve_dll(proj)
	local dll = latest_dll(proj)
	if not dll then
		dll = dap.offer_build(
			"No built output for " .. vim.fn.fnamemodify(proj, ":t") .. ".\nRun 'dotnet build' now?",
			{ "dotnet", "build", proj },
			function() return latest_dll(proj) end
		)
	end
	return dll
end

--- Project to debug (asked if ambiguous) and the dll to launch (confirmed or overridden).
local function resolve_program()
	local candidates = project_candidates()

	if #candidates == 0 then
		vim.notify("no .csproj found under " .. vim.fn.getcwd(), vim.log.levels.WARN)
		return nil
	end
	local proj = dap.pick(candidates, "Debug project: ", function(p) return vim.fn.fnamemodify(p, ":.") end)
	if not proj then return nil end

	local dll = resolve_dll(proj)
	if not dll then
		vim.notify("no built dll found for " .. proj .. "; run 'dotnet build' first", vim.log.levels.WARN)
		return nil
	end

	return vim.fn.input("Path to dll: ", dll, "file")
end

--- Running `dotnet` processes as { pid, label } — Aspire services run as
--- `dotnet exec <Service>.dll`; the label is that dll's name when present.
local function dotnet_processes()
	local procs = {}
	for _, line in ipairs(vim.fn.system({ "pgrep", "-a", "dotnet" })) do
		local pid, args = line:match("^(%d+)%s+(.*)$")
		if pid then
			local dll = args:match("([%w_%.%-]+%.dll)")
			local label = (dll and vim.fn.fnamemodify(dll, ":t") or vim.fn.split(args, " ")[1]) .. " (pid " .. pid .. ")"
			procs[#procs + 1] = { pid = tonumber(pid), label = label }
		end
	end
	return procs
end

--- Pid of the process to attach to (asked when several run, e.g. an Aspire app's services).
local function resolve_pid()
	local procs = dotnet_processes()
	if #procs == 0 then
		vim.notify("no running dotnet processes; start the app (aspire run) first", vim.log.levels.WARN)
		return ABORT
	end

	local pid_by_label, labels = {}, {}
	for _, p in ipairs(procs) do
		labels[#labels + 1] = p.label
		pid_by_label[p.label] = p.pid
	end

	local label = dap.pick(labels, "Attach to: ")
	return label and pid_by_label[label] or ABORT
end

dap.register("cs", {
	mason = "netcoredbg",
	name = "netcoredbg",
	adapter = {
		type = "executable",
		command = "netcoredbg",
		args = { "--interpreter=vscode" },
	},
	configurations = {
		{
			type = "netcoredbg",
			name = "Launch .NET",
			request = "launch",
			program = resolve_program,
			cwd = vim.fn.getcwd(),
			stopOnEntry = false,
		},
		{
			type = "netcoredbg",
			name = "Attach to .NET process",
			request = "attach",
			processId = resolve_pid,
		},
	},
})
