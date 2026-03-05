return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		picker = {
			enabled = true,
			formatters = {
				file = {
					filename_first = true,
					truncate = "left",
				},
			},
			sources = {
				files = {
					exclude = {
						"**/.git",
						"**/node_modules",
						"**/dist",
						"**/build",
					},
					hidden = true,
				},
			},
		},
		explorer = {
			enabled = true,
		},
		statuscolumn = { enabled = true },
		indent = { enabled = true },

		bigfile = { enabled = false },
		dashboard = { enabled = false },
		input = { enabled = false },
		notifier = { enabled = false },
		quickfile = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
		words = { enabled = false },
	},
	keys = {
		-- Top Pickers & Explorer
		{ "<leader><space>", function() require("snacks").picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>,", function() require("snacks").picker.buffers() end, desc = "Buffers" },
		{ "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command History" },
		{ "<leader>n", function() require("snacks").picker.notifications() end, desc = "Notification History" },
		{ "<leader>e", function() require("snacks").explorer() end, desc = "File Explorer" },

		-- find
		{ "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
		{ "<leader>fg", function() require("snacks").picker.grep() end, desc = "Find Grep" },
		{
			"<leader>fc",
			function() require("snacks").picker.files({ cwd = vim.fn.stdpath("config") }) end,
			desc = "Find Config File",
		},
		{ "<leader>ff", function() require("snacks").picker.files() end, desc = "Find Files" },
		{ "<leader>fp", function() require("snacks").picker.projects() end, desc = "Projects" },
		{ "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent" },
	},
}
