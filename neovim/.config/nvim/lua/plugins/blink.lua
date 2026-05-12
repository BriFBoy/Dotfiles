local cmp = require("blink.cmp")
cmp.setup({
	keymap = { preset = "default" },
	completion = {
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
			show_on_backspace = true,
			show_on_backspace_in_keyword = true,
			show_on_backspace_after_accept = true,
			show_on_backspace_after_insert_enter = true,
		},
		ghost_text = {
			enabled = true,
		},
		documentation = { auto_show = true },
		keyword = {
			range = "full",
		},
	},
	signature = {
		enabled = true,
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			snippets = {
				opts = {
					friendly_snippets = true,
				},
			},
			lsp = {
				min_keyword_length = 0,
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
