return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	opts = {
		theme = "hyper",
		config = {
			header = {
				"██████╗ ██████╗ ██╗███████╗██████╗  ██████╗ ██╗   ██╗",
				"██╔══██╗██╔══██╗██║██╔════╝██╔══██╗██╔═══██╗╚██╗ ██╔╝",
				"██████╔╝██████╔╝██║█████╗  ██████╔╝██║   ██║ ╚████╔╝ ",
				"██╔══██╗██╔══██╗██║██╔══╝  ██╔══██╗██║   ██║  ╚██╔╝  ",
				"██████╔╝██║  ██║██║██║     ██████╔╝╚██████╔╝   ██║   ",
				"╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝     ╚═════╝  ╚═════╝    ╚═╝   ",
			},
			footer = {},
		},
		hide = {
			statusline = false,
			tabline = false,
			winbar = false,
		},
	},
}
