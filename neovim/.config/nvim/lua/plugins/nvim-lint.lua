local function setup_lint(languages)
	local lint = require("lint")

	-- build linters_by_ft from tools.lua
	for ft, lang in pairs(languages) do
		if lang.linter then
			-- supports single linter or a list
			lint.linters_by_ft[ft] = type(lang.linter) == "table" and lang.linter or { lang.linter }
		end
	end

	-- trigger linting on save
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function() lint.try_lint() end,
	})
end

setup_lint(require("language"))
