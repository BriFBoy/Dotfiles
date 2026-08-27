local mason = require("core.mason")

mason.ensure("clangd")
mason.ensure("clang-format")
mason.ensure("cpplint")

for _, ft in ipairs({ "c", "cpp" }) do
	require("core.format").register(ft, "clang-format")
end
-- cpplint is C++-oriented; plain C relies on clangd's own diagnostics
require("core.lint").register("cpp", "cpplint")

vim.lsp.config("clangd", {})
vim.lsp.enable("clangd")
