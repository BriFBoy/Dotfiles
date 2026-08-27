local cmp = require("blink.cmp")
local fzf = require("fzf-lua")

vim.lsp.config("*", {
	capabilities = cmp.get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = function(desc)
			return { buffer = args.buf, desc = desc }
		end

		-- Navigation (fzf-lua pickers)
		vim.keymap.set("n", "gd", fzf.lsp_definitions, opts("Go to Definition"))
		vim.keymap.set("n", "gi", fzf.lsp_implementations, opts("Go to Implementation"))
		vim.keymap.set("n", "gt", fzf.lsp_typedefs, opts("Go to Type Definition"))
		vim.keymap.set("n", "gr", fzf.lsp_references, opts("Find References"))
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts("Signature Help"))

		-- Code actions & edits
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename Symbol"))
		vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, opts("Code actions"))
		vim.keymap.set("n", "<leader>cd", fzf.diagnostics_document, opts("Document Diagnostics"))
		vim.keymap.set("n", "<leader>cD", fzf.diagnostics_workspace, opts("Workspace Diagnostics"))

		-- Symbols
		vim.keymap.set("n", "<leader>ds", fzf.lsp_document_symbols, opts("Document Symbols"))
		vim.keymap.set("n", "<leader>ws", fzf.lsp_workspace_symbols, opts("Workspace Symbols"))

		-- Hover
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Shows Hover Info"))
	end,
})
