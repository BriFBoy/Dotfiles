require("keymaps")
require("config.lazy")

vim.cmd("set relativenumber")
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.opt.linespace = 4

vim.cmd("set clipboard+=unnamedplus")
