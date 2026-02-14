return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	opts = {
		window = {
			position = "left",
			width = 30,
			mapping_options = {
				noremap = true,
				nowait = true,
			},
		},
		filesystem = {
			filtered_items = {
				visible = false, -- when true, they will just be displayed differently than normal items
				hide_dotfiles = false,
				hide_gitignored = true,
			},
		},
	},
	keys = {
		{ "<leader>ts", "<cmd>Neotree filesystem reveal left<CR>", desc = "Neotree tree show" },
		{ "<leader>th", "<cmd>Neotree close<CR>", desc = "Neotree tree hide" },
	},
}
