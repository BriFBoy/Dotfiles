local mason = require("core.mason")

mason.ensure("python-lsp-server")
mason.ensure("black")
mason.ensure("ruff")

require("core.format").register("python", "black")
require("core.lint").register("python", "ruff")

vim.lsp.config("pylsp", {})
vim.lsp.enable("pylsp")
