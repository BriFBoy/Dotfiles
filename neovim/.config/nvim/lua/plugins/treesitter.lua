return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  opts = {},
  init = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = { "lua", "javascript", "java" },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end

}

