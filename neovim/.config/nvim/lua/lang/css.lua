local mason = require("core.mason")

mason.ensure("css-lsp")
mason.ensure("biome")

-- biome-check = format + safe lint fixes on save.
require("core.format").register("css", "biome-check")

vim.lsp.config("cssls", {})
vim.lsp.enable("cssls")
