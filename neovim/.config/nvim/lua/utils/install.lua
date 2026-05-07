local M = {}

function M.install_mason_tools(languages)
	local registry = require("mason-registry")

	-- refresh registry first so package names resolve correctly
	registry.refresh(function()
		local tools = {}

		for _, lang in pairs(languages) do
			if lang.lsp_name then vim.lsp.enable(lang.lsp_name) end
			for _, key in ipairs({ "lsp", "formatter", "linter" }) do
				if lang[key] then tools[lang[key]] = true end
			end
		end

		for tool in pairs(tools) do
			-- has_package checks the registry exists before trying to get it
			if not registry.has_package(tool) then
				vim.notify("Unknown package: " .. tool, vim.log.levels.WARN)
			else
				vim.notify("Installing " .. tool .. "...", vim.log.levels.INFO)
				registry.get_package(tool):install()
			end
		end
	end)
end

return M
