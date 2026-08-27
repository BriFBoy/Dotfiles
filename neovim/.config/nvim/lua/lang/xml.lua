local mason = require("core.mason")

mason.ensure("lemminx")
mason.ensure("xmlformatter")

require("core.format").register("xml", "xmlformatter")

vim.lsp.config("lemminx", {})
vim.lsp.enable("lemminx")
