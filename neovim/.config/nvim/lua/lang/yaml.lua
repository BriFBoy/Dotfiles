-- YAML: yamlls (LSP) + prettier + yamllint.

local mason = require("core.mason")

mason.ensure("yaml-language-server")
mason.ensure("prettier")
mason.ensure("yamllint")

-- prettier: the Mason Biome release can't format YAML yet.
require("core.format").register("yaml", "prettier")
require("core.lint").register("yaml", "yamllint")

-- yamlls fetches the SchemaStore catalog itself and matches schemas by
-- file name (GitHub workflows, compose, k8s, ...).
vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			validate = true,
			completion = true,
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
		},
	},
})
vim.lsp.enable("yamlls")
