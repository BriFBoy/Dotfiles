local mason = require("core.mason")

mason.ensure("json-lsp")
mason.ensure("biome")

require("core.format").register("json", "biome")

vim.lsp.config("jsonls", {})
vim.lsp.enable("jsonls")
