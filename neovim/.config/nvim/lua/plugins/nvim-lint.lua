return {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" }, -- for .jsx
			typescriptreact = { "eslint_d" }, -- for .tsx
			java = { "checkstyle" },
			c = { "clangtidy" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			zsh = { "shellcheck" },
			lua = { "luacheck" },
		},
	},
	config = function()
		local lint = require("lint")
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
