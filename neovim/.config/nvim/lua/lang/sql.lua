-- Dialect-agnostic SQL: sqls (LSP) + sleek (formatter).
-- No sqlfluff, since it requires a dialect.

local mason = require("core.mason")

mason.ensure("sleek")
mason.ensure("sqls")

require("core.format").register("sql", "sleek")

vim.lsp.config("sqls", {})
vim.lsp.enable("sqls")
