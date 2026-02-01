return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			automatic_enable = {
				ensure_installed = {
					"lua_ls",
					"jdtls",
					"clangd",

					-- Javascript/Typescript + css
					"eslint",
					"cssls",
					"tailwindcss",
				},
				exclude = {
					"jdtls",
				},
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- Formatters
				"prettier",
				"stylua",
				"clang-format",
				"google-java-format",
				"beautysh",

				-- Linters
				"eslint_d",
				"htmlhint",
				"stylelint",
				"shellcheck",
				"luacheck",
				"cpplint",
			},

			auto_update = false,
			run_on_start = true,
		},
	},
}
