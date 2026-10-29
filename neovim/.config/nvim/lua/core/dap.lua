local dap = require("dap")
local dapui = require("dapui")

require("mason-nvim-dap").setup()

-- Inline variable values next to the code while stepping.
require("nvim-dap-virtual-text").setup({})

-- Docked layout: slim sidebar on the left, repl/console along the bottom
dapui.setup({
	layouts = {
		{
			elements = {
				{ id = "stacks", size = 0.3 },
				{ id = "scopes", size = 0.5 },
				{ id = "breakpoints", size = 0.2 },
			},
			size = 28,
			position = "left",
		},
		{
			elements = { "repl", "console" },
			size = 10,
			position = "bottom",
		},
	},
})

-- Open the UI on session start; it stays open after exit (close with <leader>du)
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })

local M = {}

--- Register a debug adapter and its launch configurations for a language.
---@param filetype string  e.g. "cs" (where configurations are attached)
---@param spec table       { mason?: string, name?: string, adapter?: table, adapters?: table<string, table>, configurations?: table }
function M.register(filetype, spec)
	if spec.mason then
		require("core.mason").ensure(spec.mason)
	end
	if spec.adapter then
		-- nvim-dap resolves a configuration's `type` against `dap.adapters`, so the
		-- adapter must be keyed by its own name (the same string the configs' `type` uses).
		-- Note: this is NOT the adapter's `type` field (that's the transport, e.g. "executable").
		local name = spec.name or filetype
		dap.adapters[name] = spec.adapter
	end
	-- Same as `adapter`, for servers that answer under several names
	-- (e.g. js-debug's pwa-node / pwa-chrome): map of adapter name -> adapter.
	for name, adapter in pairs(spec.adapters or {}) do
		dap.adapters[name] = adapter
	end
	if spec.configurations then
		dap.configurations[filetype] = spec.configurations
	end
end

-- Debug-target discovery helpers (see lang/rust.lua, lang/csharp.lua)

---@param path string
---@return number  modification time in seconds, 0 if the file is missing
function M.mtime(path)
	local stat = vim.uv.fs_stat(path)
	return stat and stat.mtime and stat.mtime.sec or 0
end

--- Sort file paths newest-first (in place).
---@param paths string[]
---@return string[]
function M.sort_newest(paths)
	table.sort(paths, function(a, b)
		return M.mtime(a) > M.mtime(b)
	end)
	return paths
end

--- Pick one of several candidates; the only one is returned without prompting.
--- With several, must run inside a coroutine (nvim-dap config functions do);
--- returns nil on cancel, which callers should map to dap.ABORT.
---@param candidates string[]
---@param prompt string
---@param format_item? fun(item: string): string
---@return string|nil
function M.pick(candidates, prompt, format_item)
	if #candidates <= 1 then
		return candidates[1]
	end
	local co = coroutine.running()
	if not co then
		vim.notify("core.dap.pick: must be called from a coroutine", vim.log.levels.WARN)
		return nil
	end
	vim.ui.select(candidates, {
		prompt = prompt,
		format_item = format_item or function(c)
			return vim.fn.fnamemodify(c, ":t")
		end,
	}, function(choice)
		vim.schedule(function()
			coroutine.resume(co, choice)
		end)
	end)
	return coroutine.yield()
end

--- Ask to run a build command, then re-run `find` if the user agrees.
---@param prompt string
---@param cmd table  argv for vim.fn.system
---@param find fun(): any|nil
---@return any|nil
function M.offer_build(prompt, cmd, find)
	if vim.fn.confirm(prompt, "&Yes\n&No", 2) ~= 1 then
		return nil
	end
	vim.fn.system(cmd)
	return find()
end

return M
