-- UI layer: statusline, auto-pairing, and tree-sitter parser management.
-- This is a thin core module — individual languages don't register here,
-- tree-sitter-manager handles parsers on demand via `auto_install`.

require("nvim-web-devicons").setup({})

require("lualine").setup({
	options = {
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "encoding", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
})

require("nvim-autopairs").setup({
	map_cr = true,
})

require("tree-sitter-manager").setup({
	auto_install = true,
	highlight = true,
})
