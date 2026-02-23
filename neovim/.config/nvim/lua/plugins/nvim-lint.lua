return {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			-- Web developent
			javascript = { "eslint" },
			typescript = { "eslint" },
			javascriptreact = { "eslint" },
			typescriptreact = { "eslint" },
			html = { "htmlhint" },
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

		-- lint on file save or insertmode leave
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			callback = function() lint.try_lint() end,
		})
	end,
}
