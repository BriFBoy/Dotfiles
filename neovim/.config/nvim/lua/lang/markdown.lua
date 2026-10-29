-- Markdown: marksman (LSP) + markdownlint-cli2 + render-markdown.

local mason = require("core.mason")

mason.ensure("marksman")
mason.ensure("markdownlint-cli2")

-- No formatter: the Mason Biome release can't format Markdown yet.
require("core.lint").register("markdown", "markdownlint-cli2")

vim.lsp.config("marksman", {})
vim.lsp.enable("marksman")

require("render-markdown").setup({
	completions = {
		lsp = { enabled = true },
	},
})
