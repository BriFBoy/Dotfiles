require("keymaps")
require("config.neovim")
local languages = require("language")

-- Plugins
require("plugins")

-- Colorscheme
local neopywal = require("neopywal")
neopywal.setup()
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
require("nvim-autopairs").setup()
require("nvim-ts-autotag").setup({
	aliases = {
		["rust"] = "html",
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
