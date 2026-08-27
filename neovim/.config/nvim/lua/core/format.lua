local conform = require("conform")

--- Empty microkernel registry. Language drivers populate this via `register()`
--- as soon as their ftplugin loads, so formatters stay colocated with the
--- language that owns them. `conform.formatters_by_ft` is a plain table read
--- lazily at format-time, so late registration works without re-setup.
local M = {}

--- Register one or more formatters for a filetype.
---@param filetype string
---@param formatters string|string[]  conform formatter name(s)
function M.register(filetype, formatters)
	if type(formatters) == "string" then formatters = { formatters } end
	conform.formatters_by_ft[filetype] = formatters
end

conform.setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

return M
