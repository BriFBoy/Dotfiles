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
	{ src = urls.gh("rafamadriz/friendly-snippets") },
	-- Debugging
	urls.gh("mfussenegger/nvim-dap"),
	-- languages
	{
		src = urls.gh("mrcjkb/rustaceanvim"),
		version = vim.version.range("^9"),
	},
	urls.gh("nvim-java/nvim-java"),
	{
		src = urls.gh("JavaHello/spring-boot.nvim"),
		version = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
	},
	urls.gh("MunifTanjim/nui.nvim"),
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
require("plugins.blink")
require("java").setup()
-- Mason
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
-- Formatting and linting
require("plugins.conform")
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
require("config.lsp")

-- Custom commands
vim.api.nvim_create_user_command(
	"LangInstall",
	function() require("utils.install").install_mason_tools(languages) end,
	{}
)
