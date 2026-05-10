require("keymaps")
require("config.neovim")
local urls = require("utils.urls")
local languages = require("language")

vim.pack.add({
	{ src = urls.gh("RedsXDD/neopywal.nvim"), name = "neopywal" },
	{ src = urls.gh("romus204/tree-sitter-manager.nvim"), name = "tree-sitter-manager" },
	{ src = urls.gh("folke/snacks.nvim"), name = "snacks" },
	{ src = urls.gh("nvim-tree/nvim-web-devicons") },
	{ src = urls.gh("lewis6991/gitsigns.nvim") },
	{ src = urls.gh("nvim-lualine/lualine.nvim") },
	{ src = urls.gh("mason-org/mason.nvim") },
	-- Lsp
	{ src = urls.gh("neovim/nvim-lspconfig") },
	-- Formatting and linting
	{ src = urls.gh("stevearc/conform.nvim") },
	-- Autocompletion
	{ src = urls.gh("saghen/blink.cmp"), version = vim.version.range(">=1.10") },
	-- languages
	{
		src = urls.gh("mrcjkb/rustaceanvim"),
		version = vim.version.range("^9"),
	},
	{ src = urls.cb("mfussenegger/nvim-jdtls") },
	{ src = urls.gh("seblj/roslyn.nvim"), name = "roslyn" },
})

-- Plugins
require("neopywal").setup()
vim.cmd.colorscheme("neopywal")
vim.api.nvim_set_hl(0, "String", { fg = "#7bcc52" })
require("tree-sitter-manager").setup({
	auto_install = true,
})
require("plugins.snacks")
require("gitsigns")
require("plugins.lualine")
require("plugins.nvim-jdtls")
-- Mason
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
-- Formatting and linting
require("plugins.conform")
-- Autocompletion
local cmp = require("blink.cmp")
cmp.setup({
	keymap = { preset = "default" },
	completion = {
		trigger = {
			show_on_keyword = true,
			show_on_trigger_character = true,
			show_on_backspace = true,
			show_on_backspace_in_keyword = true,
			show_on_backspace_after_accept = true,
			show_on_backspace_after_insert_enter = true,
		},
		ghost_text = {
			enabled = true,
		},
		documentation = { auto_show = true },
		keyword = {
			range = "full",
		},
	},
	signature = {
		enabled = true,
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			lsp = {
				min_keyword_length = 0,
			},
		},
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})
-- Enabling all LSPs
for _, lang in pairs(languages) do
	if type(lang.lsp_name) == "table" then
		for _, name in ipairs(lang.lsp_name) do
			vim.lsp.enable(name)
		end
	elseif type(lang.lsp_name) == "string" then
		vim.lsp.enable(lang.lsp_name)
	end
end

-- Lsp
vim.lsp.config["lua_ls"] = {
	settings = {
		Lua = {
			diagnostics = {
				globals = {
					"vim",
				},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
-- Custom commands
vim.api.nvim_create_user_command(
	"LangInstall",
	function() require("utils.install").install_mason_tools(languages) end,
	{}
)
