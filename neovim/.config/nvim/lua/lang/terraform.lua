local mason = require("core.mason")

mason.ensure("terraform-ls")
mason.ensure("terraform")
mason.ensure("tflint")

require("core.format").register("terraform", "terraform_fmt")
require("core.lint").register("terraform", "tflint")

vim.lsp.config("terraformls", {})
vim.lsp.enable("terraformls")
