local lint = require("lint")

--- Empty microkernel registry. Language drivers populate this via `register()`
--- as soon as their ftplugin loads. `lint.linters_by_ft` is a plain table read
--- at lint-time, so late registration works without re-setup.
local M = {}

--- Register one or more linters for a filetype.
---@param filetype string
---@param linters string|string[]  nvim-lint linter name(s)
function M.register(filetype, linters)
	if type(linters) == "string" then linters = { linters } end
	lint.linters_by_ft[filetype] = linters
end

vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function() lint.try_lint() end,
})

return M
