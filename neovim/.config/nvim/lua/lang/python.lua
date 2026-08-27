local mason = require("core.mason")

mason.ensure("ruff")
mason.ensure("black")

require("core.format").register("python", "black")

-- ruff is the LSP; its lint diagnostics come through the LSP, so no
-- separate nvim-lint registration (that would double every finding)
vim.lsp.config("ruff", {})
vim.lsp.enable("ruff")
