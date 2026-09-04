local mason = require("core.mason")

mason.ensure("css-lsp")
mason.ensure("prettier")
mason.ensure("stylelint")

require("core.format").register("css", "prettier")
require("core.lint").register("css", "stylelint")

vim.lsp.config("cssls", {})
vim.lsp.enable("cssls")
