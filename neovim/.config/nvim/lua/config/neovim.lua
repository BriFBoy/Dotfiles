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
vim.lsp.inlay_hint.enable(true)
