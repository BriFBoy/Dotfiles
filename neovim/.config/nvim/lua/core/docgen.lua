local neogen = require("neogen")

--- Empty microkernel registry. Language drivers set their doc-comment
--- convention via `register()`. neogen.setup() resets to its defaults on every
--- call, so the full config is rebuilt from this table each time.
local M = {}

local languages = {}

local function apply() neogen.setup({ snippet_engine = "luasnip", languages = languages }) end

--- Template item names (Parameter, Return, Throw, ...) for custom templates,
--- so drivers don't require neogen modules directly.
M.item = require("neogen.types.template").item

--- Set the doc-comment style for a filetype.
---@param filetype string
---@param spec string|table  neogen annotation_convention (e.g. "xmldoc"), or a
---                          full neogen language configuration table
function M.register(filetype, spec)
	languages[filetype] = type(spec) == "string" and { template = { annotation_convention = spec } } or spec
	apply()
end

apply()

vim.keymap.set("n", "<leader>cg", function() neogen.generate() end, { desc = "Generate doc comment" })
vim.keymap.set(
	"n",
	"<leader>cG",
	function() neogen.generate({ type = "class" }) end,
	{ desc = "Generate class doc comment" }
)

return M
