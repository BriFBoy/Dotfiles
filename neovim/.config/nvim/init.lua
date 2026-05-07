require("keymaps")
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
	{ src = urls.gh("mfussenegger/nvim-lint") },
	-- Autocompletion
	{ src = urls.gh("saghen/blink.cmp"), version = vim.version.range("1.0") },
	{ src = urls.gh("rafamadriz/friendly-snippets") },
	-- Rust
	{
		src = urls.gh("mrcjkb/rustaceanvim"),
		version = vim.version.range("^9"),
	},
	-- Java
	{
		src = urls.gh("JavaHello/spring-boot.nvim"),
		version = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
	},
	urls.gh("MunifTanjim/nui.nvim"),
	urls.gh("mfussenegger/nvim-dap"),
	urls.gh("nvim-java/nvim-java"),
	-- C#
	{ src = urls.gh("seblj/roslyn.nvim"), name = "roslyn" },
})

vim.o.relativenumber = true
vim.o.number = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.linespace = 4
vim.o.termguicolors = true
vim.o.scrolloff = 12
vim.o.signcolumn = "yes"
vim.opt.clipboard:append("unnamedplus")
vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
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
require("java").setup()
-- Mason
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
for _, lang in pairs(languages) do
	if type(lang.lsp_name) == "table" then
		for _, name in ipairs(lang.lsp_name) do
			vim.lsp.enable(name)
		end
	elseif type(lang.lsp_name) == "string" then
		vim.lsp.enable(lang.lsp_name)
	end
end
-- Formatting and linting
require("plugins.conform")
require("plugins.nvim-lint")
-- Autocompletion
require("blink.cmp").setup({
	keymap = { preset = "default" },
	completion = { documentation = { auto_show = true } },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

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
