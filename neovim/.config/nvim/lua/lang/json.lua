-- JSON: jsonls (LSP) + biome-check (formatter).

local mason = require("core.mason")

mason.ensure("json-lsp")
mason.ensure("biome")

-- biome-check = format + safe lint fixes on save.
require("core.format").register("json", "biome-check")

-- jsonls can't fetch the SchemaStore catalog by itself; it still validates
-- against "$schema" references in the file.
vim.lsp.config("jsonls", {
	filetypes = { "json" },
	settings = {
		json = { validate = { enable = true } },
	},
})
vim.lsp.enable("jsonls")
