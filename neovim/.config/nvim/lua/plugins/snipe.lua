return {
	"leath-dub/snipe.nvim",
	keys = {
		{
			"<leader>s",
			function()
				require("snipe").open_buffer_menu()
			end,
			desc = "Open Snipe buffer menu",
		},
	},
	opts = {
		preselect_current = true,
		navigate = {
			cancel_snipe = "q",
			close_buffer = "d",
		},
		sort = "default",
	},
}
