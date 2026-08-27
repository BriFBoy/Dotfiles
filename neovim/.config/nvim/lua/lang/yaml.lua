local mason = require("core.mason")

mason.ensure("yaml-language-server")
mason.ensure("prettier")
mason.ensure("yamllint")

require("core.format").register("yaml", "prettier")
require("core.lint").register("yaml", "yamllint")

vim.lsp.config("yamlls", {})
vim.lsp.enable("yamlls")
