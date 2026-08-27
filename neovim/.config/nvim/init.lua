-- Leader must be set before any keymap setup (core.navigation runs early)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core.pack")
require("core.navigation")
require("core.mason")
require("core.config")
require("core.theme")
require("core.autocomplete")
require("core.lsp")
require("core.keymaps")
require("core.format")
require("core.lint")
require("core.git")
require("core.ui")
require("core.dap")
