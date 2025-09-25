return {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    opts = {},
    
    -- sets the colorscheme to neopywal on startup
    init = function ()
        vim.cmd.colorscheme("neopywal")
    end
}