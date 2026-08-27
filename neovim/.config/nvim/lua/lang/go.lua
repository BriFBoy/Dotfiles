local mason = require("core.mason")

mason.ensure("gopls")
mason.ensure("golangci-lint")
mason.ensure("gofumpt")

require("core.format").register("go", "gofumpt")
require("core.lint").register("go", "golangcilint")

vim.lsp.config("gopls", {})
vim.lsp.enable("gopls")
