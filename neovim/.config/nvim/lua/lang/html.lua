-- HTML: html LSP, which also formats.

local mason = require("core.mason")

mason.ensure("html-lsp")

-- No conform formatter: Biome's HTML formatter is disabled unless a
-- biome.json opts in, so format_on_save falls back to the html LSP.
vim.lsp.config("html", {})
vim.lsp.enable("html")
