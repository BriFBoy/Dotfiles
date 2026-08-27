local luasnip = require("luasnip")
luasnip.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_autosnippets = true,
})

-- Build the native fuzzy library (no-op if already built for this revision)
require("blink.cmp").build():pwait()

require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	keymap = { preset = "default" },
	completion = {
		menu = {
			border = "rounded",
		},
		documentation = {
			-- keep the doc window out of the way; open manually with <C-/>
			auto_show = false,
		},
	},
})
