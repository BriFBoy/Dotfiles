local mason = require("core.mason")

mason.ensure("dockerfile-language-server")
mason.ensure("hadolint")

require("core.lint").register("dockerfile", "hadolint")

vim.lsp.config("dockerls", {})
vim.lsp.enable("dockerls")
