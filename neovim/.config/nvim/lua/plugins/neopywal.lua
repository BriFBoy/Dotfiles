return {
	"RedsXDD/neopywal.nvim",
	name = "neopywal",
	lazy = false,
	priority = 1000,
	-- sets the colorscheme to neopywal on startup
	init = function()
		vim.cmd.colorscheme("neopywal")
		vim.api.nvim_set_hl(0, "String", { fg = "#689F38" })
	end,
}
