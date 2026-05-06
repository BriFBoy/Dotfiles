require("keymaps")
local urls = require("lua/utils/urls")

vim.pack.add({
  {	src = urls.gh("RedsXDD/neopywal.nvim"), name = "neopywal" },
  { src = urls.gh("romus204/tree-sitter-manager.nvim"), name = "tree-sitter-manager" },
  { src = urls.gh("folke/snacks.nvim"), name = "snacks"},
  { src = urls.gh("nvim-tree/nvim-web-devicons") },
  { src = urls.gh("lewis6991/gitsigns.nvim") },
  { src = urls.gh("nvim-lualine/lualine.nvim") },
})

vim.cmd("set relativenumber")
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.opt.linespace = 4

vim.cmd("set clipboard+=unnamedplus")

-- Plugins
require("neopywal").setup()
vim.cmd.colorscheme("neopywal")

require("tree-sitter-manager").setup({
  ensure_installed = {"java", "c_sharp", "c", "rust", "javascript", "typescript", "lua",},
  auto_install = true,
})

require("lua/plugins/snacks")
require("gitsigns")
require("lua/plugins/lualine")
