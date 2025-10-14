return {
	"windwp/nvim-autopairs",
	dependencies = {
		{
			"windwp/nvim-ts-autotag",
			opts = {
				enable_close_on_slash = false,
			},
		},
	},
	event = "InsertEnter",
	config = true,
}
