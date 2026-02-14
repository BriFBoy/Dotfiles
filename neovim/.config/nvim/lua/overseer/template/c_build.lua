return {
	name = "C: Build Project",
	condition = {
		filetype = { "c", "cpp" },
	},
	builder = function()
		local cwd = vim.fn.getcwd()
		local env = require("utils.env").load_env(cwd .. "/.env")
		local has_makefile = vim.fn.filereadable(cwd .. "/Makefile") == 1
			or vim.fn.filereadable(cwd .. "/makefile") == 1

		if not has_makefile then
			return {
				cmd = { "echo" },
				args = { "No Makefile found in: " .. cwd },
				cwd = cwd,
				env = env,
				components = { "default" },
			}
		end

		return {
			cmd = { "make" },
			args = {},
			cwd = cwd,
			env = env,
			components = { "default" },
		}
	end,
}
