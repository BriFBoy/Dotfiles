-- Editing enhancements: auto-pairing (brackets/quotes) and treesitter-based
-- tag auto-close/rename. Language-agnostic; each plugin applies only where the
-- relevant filetype or parser is present.
require("nvim-autopairs").setup({
	map_cr = true,
})

require("nvim-ts-autotag").setup({})
