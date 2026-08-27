-- Colorscheme: neopywal.nvim reads the palette pywal generated from the
-- current wallpaper (~/.cache/wal) and applies it to Neovim, re-applying
-- automatically when pywal regenerates colors.
--
-- Load the explicit "-dark" variant: the plain `colorscheme neopywal`
-- auto-detects the variant from `vim.o.background`, which can invert a
-- pywal-generated palette (upstream docs recommend pinning the variant).
-- Mix two #rrggbb colors: result = a moved t towards b.
local function mix(a, b, t)
	local function parse(h)
		return tonumber(h:sub(2, 3), 16), tonumber(h:sub(4, 5), 16), tonumber(h:sub(6, 7), 16)
	end
	local r1, g1, b1 = parse(a)
	local r2, g2, b2 = parse(b)
	local f = function(x, y)
		return string.format("%02x", math.floor(x + (y - x) * t + 0.5))
	end
	return "#" .. f(r1, r2) .. f(g1, g2) .. f(b1, b2)
end

require("neopywal").setup({
	-- Enable the built-in nvim-dap / dap-ui highlight sets (off by default);
	-- without them dap-ui renders as plain editor text.
	plugins = {
		dap = true,
		dap_ui = true,
	},
	custom_highlights = {
		all = function(C)
			return {
				-- Subtle lifted surface for the dap-ui panels (nvim_set_hl
				-- can't take alpha, so blend by hand from the palette)
				DapUINormal = { bg = mix(C.background, C.color8, 0.18) },
				-- IntelliJ Darcula-style green for string literals
				String = { fg = "#6a8759" },
			["@string"] = { fg = "#6a8759" },
			-- The built-in dap/dap_ui sets reference palette keys the pywal
				-- source doesn't provide (C.ok/warn/error/unnecessary), so give
				-- those groups real colors:
				DapBreakpoint = { fg = C.color2 },
				DapBreakpointCondition = { fg = C.color3 },
				DapBreakpointRejected = { fg = C.color1 },
				DapStoppedLine = { bg = C.color3, styles = { "bold" } },
				DapUIModifiedValue = { fg = C.color3 },
				DapUIStop = { fg = C.color1 },
				DapUIStopNC = { fg = C.color1 },
				DapUIWatchesEmpty = { fg = C.color3 },
				DapUIWatchesError = { fg = C.color1 },
				DapUIUnavailable = { fg = C.color8 },
				DapUIUnavailableNC = { fg = C.color8 },
				DapUIBreakpointsDisabledLine = { fg = C.color8 },
			}
		end,
	},
})
vim.cmd.colorscheme("neopywal-dark")
