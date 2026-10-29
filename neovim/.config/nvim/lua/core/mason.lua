require("mason").setup({
	ui = {
		icons = {
			package_installed = "",
			package_pending = "",
			package_uninstalled = "",
		},
	},
})

-- Make mason-installed binaries (formatters, linters, LSPs) discoverable on PATH
-- so external commands like `black`, `stylua`, `terraform` resolve without extra wiring.
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. (vim.env.PATH or "")

local registry = require("mason-registry")

local M = {}

--- Package names with an install in flight this session.
local pending = {}

--- Install a mason package if it is not already installed.
--- Safe to call repeatedly (e.g. from every ftplugin): no-op if the package is
--- installed or an install is already in flight; unknown names are ignored.
---@param name string  mason package name
function M.ensure(name)
	if pending[name] or registry.is_installed(name) then
		return
	end
	pending[name] = true
	registry.refresh(function()
		if registry.is_installed(name) or not registry.has_package(name) then
			pending[name] = nil
			return
		end
		local pkg = registry.get_package(name)
		if pkg.is_installing and pkg:is_installing() then
			pending[name] = nil
			return
		end
		pkg:install({}, function()
			pending[name] = nil
		end)
	end)
end

return M
