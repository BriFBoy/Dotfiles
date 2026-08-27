local mason = require("core.mason")

mason.ensure("taplo")

-- taplo's linter runs inside the LSP (diagnostics), enabled by default
require("core.format").register("toml", "taplo")

vim.lsp.config("taplo", {})
vim.lsp.enable("taplo")
