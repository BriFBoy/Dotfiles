return {
	"norcalli/nvim-colorizer.lua",
	opts = {
		DEFAULT_OPTIONS = {
			RGB = true, -- #RGB hex codes
			RRGGBB = true, -- #RRGGBB hex codes
			names = true, -- "Name" codes like Blue
			RRGGBBAA = false, -- #RRGGBBAA hex codes
			rgb_fn = true, -- CSS rgb() and rgba() functions
			hsl_fn = false, -- CSS hsl() and hsla() functions
			css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
			css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			-- Available modes: foreground, background
			mode = "background", -- Set the display mode.
		},
	},
	init = function()
		vim.api.nvim_create_autocmd({ "InsertLeave", "BufReadPost" }, {
			callback = function()
				require("colorizer").attach_to_buffer(0)
			end,
		})
	end,
}
