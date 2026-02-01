return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			-- Losely typed
			lua = { "stylua" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },

			-- Web markup & styles
			html = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },

			-- Strongly typed
			java = { "google-java-format" },
			c = { "clang-format" },
			cpp = { "clang-format" },

			-- Shells
			bash = { "beautysh" },
			zsh = { "beautysh" },
			sh = { "beautysh" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
