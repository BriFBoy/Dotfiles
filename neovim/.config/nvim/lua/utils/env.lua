local M = {}

function M.load_env(path)
	local env = {}
	if vim.fn.filereadable(path) ~= 1 then
		return env
	end

	for _, line in ipairs(vim.fn.readfile(path)) do
		-- Trim whitespace around the whole line
		line = line:gsub("^%s+", ""):gsub("%s+$", "")

		-- Skip empty lines and comments
		if line ~= "" and not line:match("^#") then
			local key, val = line:match("^([A-Za-z_][A-Za-z0-9_]*)%s*=%s*(.*)$")
			if key and val then
				-- Trim whitespace around the value
				val = val:gsub("^%s+", ""):gsub("%s+$", "")

				-- Strip quotes
				val = val:gsub('^"(.*)"$', "%1")
				val = val:gsub("^'(.*)'$", "%1")

				env[key] = val
			end
		end
	end

	return env
end

return M
