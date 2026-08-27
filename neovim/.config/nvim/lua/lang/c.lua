local mason = require("core.mason")

mason.ensure("clangd")
mason.ensure("clang-format")

require("core.format").register("c", "clang-format")

vim.lsp.config("clangd", {})
vim.lsp.enable("clangd")
