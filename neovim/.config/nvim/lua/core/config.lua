-- Options
vim.o.relativenumber = true
vim.o.number = true
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.scrolloff = 12
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.confirm = true
vim.o.inccommand = "split"
vim.o.winborder = "rounded"
vim.o.cursorline = true
vim.o.breakindent = true
vim.opt.clipboard:append("unnamedplus")

-- Built-in :Undotree
pcall(vim.cmd.packadd, "nvim.undotree")

-- Folding (treesitter; LSP takes over in core/lsp.lua when supported)
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldtext = ""

-- Autoread: reload files changed outside nvim
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermClose", "TermLeave" }, {
	group = vim.api.nvim_create_augroup("core_autoread", { clear = true }),
	callback = function()
		if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
			vim.cmd.checktime()
		end
	end,
})

-- Diagnostics
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
})

-- Compose files: dotted filetype so both the yaml and docker drivers load
vim.filetype.add({
	filename = {
		["compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["docker-compose.yml"] = "yaml.docker-compose",
	},
	pattern = {
		[".*/docker%-compose%.[^/]*%.ya?ml"] = "yaml.docker-compose",
		[".*/compose%.[^/]*%.ya?ml"] = "yaml.docker-compose",
	},
})
