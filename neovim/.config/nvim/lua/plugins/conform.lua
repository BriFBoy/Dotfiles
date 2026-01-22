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

			-- Strongly typed
			java = { "google-java-format" },
			c = { "clang-format" },

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
