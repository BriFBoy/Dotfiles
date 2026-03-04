return {
	{
		"williamboman/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"jdtls",
				"clangd",
				"pylsp",
				"rust_analyzer",

				-- Javascript/Typescript + css
				"eslint",
				"cssls",
				"tailwindcss",
			},
			automatic_enable = {
				exclude = {
					"jdtls",
					"rust_analyzer",
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
				"black",
				"xmlformatter",

				-- Linters
				"eslint_d",
				"htmlhint",
				"stylelint",
				"shellcheck",
				"luacheck",
				"cpplint",
				"pylint",
			},

			auto_update = false,
			run_on_start = true,
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			ensure_installed = {
				"js",
				"codelldb",
			},
			handlers = {},
		},
	},
}
