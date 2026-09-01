local luasnip = require("luasnip")
luasnip.config.set_config({
	history = true,
	updateevents = "InsertLeave",
	enable_autosnippets = true,
})

-- Build the native fuzzy library in the background (no-op if already built).
-- Not awaited: startup continues with the Lua matcher until Rust is ready.
require("blink.cmp").build()

require("blink.cmp").setup({
	snippets = { preset = "luasnip" },
	keymap = { preset = "default" },
	completion = {
		menu = {
			border = "rounded",
		},
		documentation = {
			auto_show = true,
		},
	},
})
