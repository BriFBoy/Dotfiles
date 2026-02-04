return {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			-- Web developent
			javascript = { "eslint" },
			typescript = { "eslint" },
			javascriptreact = { "eslint" }, -- for .jsx
			typescriptreact = { "eslint" }, -- for .tsx
			html = { "htmlhint" }, -- or "tidy"
			css = { "stylelint" },

			java = { "checkstyle" },
			c = { "cpplint" },
			cpp = { "cpplint" },

			python = { "pylint" },

			-- Shells
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
