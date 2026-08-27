require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Make mason-installed binaries (formatters, linters, LSPs) discoverable on PATH
-- so external commands like `black`, `stylua`, `terraform` resolve without extra wiring.
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. (vim.env.PATH or "")

local registry = require("mason-registry")

local M = {}

--- Install a mason package if it is not already installed.
--- Safe to call repeatedly (e.g. from every ftplugin); only acts once per session.
---@param name string  mason package name
function M.ensure(name)
	-- `require('mason-registry')` triggers package indexing; guard against a
	-- not-yet-ready registry by checking availability first.
	if not registry.has_package(name) then
		return
	end
	if not registry.is_installed(name) then
		registry.get_package(name):install()
	end
end

return M
