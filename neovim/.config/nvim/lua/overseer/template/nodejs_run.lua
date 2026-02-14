return {
	name = "Node: Run project",
	condition = {
		filetype = {
			"javascript",
		},
	},

	builder = function()
		local cwd = vim.fn.getcwd()

		-- Reuse your env parser
		local env_loader = require("utils.env")
		local env = env_loader.load_env(cwd .. "/.env")

		-- Detect entry file
		local entry_files = { "index.js", "app.js", "server.js", "main.js" }
		local entry = nil

		for _, file in ipairs(entry_files) do
			if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
				entry = file
				break
			end
		end

		-- If no entry file found, return a safe dummy task
		if not entry then
			return {
				cmd = { "echo" },
				args = { "No Node.js entry file found in: " .. cwd },
				cwd = cwd,
				env = env,
				components = { "default", "open_output" },
			}
		end

		-- Normal Node.js run task
		return {
			cmd = { "node" },
			args = { entry },
			cwd = cwd,
			env = env,
			components = { "default", "open_output" },
		}
	end,
}
