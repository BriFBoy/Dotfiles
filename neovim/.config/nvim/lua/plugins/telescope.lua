return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = function()
			local sorters = require("telescope.sorters")

			return {
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						"build",
						"dist",
						".git",
						"target",
					},
					path_display = { "smart" },
					file_sorter = sorters.get_fuzzy_file,
				},
				pickers = {
					find_files = {
						follow = true,
						hidden = true,
					},
					live_grep = {
						additional_args = function()
							return {
								"--hidden",
								"--follow",
								"--no-ignore",
							}
						end,
					},
				},
				highlight = {
					enable = true,
				},
			}
		end,
		keys = {
			{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
			{ "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Telescope live grep" },
			{ "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Telescope buffers" },
			{ "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Telescope help tags" },
			{ "<leader>fo", function() require("telescope.builtin").oldfiles() end, desc = "Telescope oldfiles" },
		},
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
