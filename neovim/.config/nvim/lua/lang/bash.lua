local mason = require("core.mason")

mason.ensure("bash-language-server")
mason.ensure("shfmt")
mason.ensure("shellcheck")

for _, ft in ipairs({ "bash", "sh" }) do
	require("core.format").register(ft, "shfmt")
	require("core.lint").register(ft, "shellcheck")
end

vim.lsp.config("bashls", {})
vim.lsp.enable("bashls")
