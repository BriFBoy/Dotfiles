local cmp = require("blink.cmp")
local fzf = require("fzf-lua")

vim.lsp.config("*", {
	capabilities = cmp.get_lsp_capabilities(),
})

--- Per-buffer augroup, e.g. "core_lsp_highlight_12".
local function buf_group(name, buf)
	return "core_lsp_" .. name .. "_" .. buf
end

--- Whether any attached client (optionally excluding one) supports `method`.
local function buf_supports(buf, method, except_id)
	for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf, method = method })) do
		if c.id ~= except_id then
			return true
		end
	end
	return false
end

-- Highlight references of the symbol under the cursor
local function setup_highlight(buf)
	local group = vim.api.nvim_create_augroup(buf_group("highlight", buf), { clear = true })
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = group,
		buffer = buf,
		callback = vim.lsp.buf.document_highlight,
	})
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		group = group,
		buffer = buf,
		callback = vim.lsp.buf.clear_references,
	})
end

-- Prefer LSP folding over treesitter, including windows opened later (:split)
local function setup_folding(buf)
	local foldexpr = "v:lua.vim.lsp.foldexpr()"
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.wo[win][0].foldexpr = foldexpr
	end
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = vim.api.nvim_create_augroup(buf_group("fold", buf), { clear = true }),
		buffer = buf,
		callback = function(ev)
			if buf_supports(ev.buf, "textDocument/foldingRange") then
				vim.wo[0][0].foldexpr = foldexpr
			end
		end,
	})
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("core_lsp", { clear = true }),
	callback = function(args)
		local buf = args.buf
		local opts = function(desc)
			return { buffer = buf, desc = desc }
		end

		-- Inlay hints are opt-in since 0.12; no-op for servers without them
		vim.lsp.inlay_hint.enable(true, { bufnr = buf })

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if client:supports_method("textDocument/documentHighlight") then
			setup_highlight(buf)
		end
		if client:supports_method("textDocument/codeLens") then
			vim.lsp.codelens.enable(true, { bufnr = buf })
		end
		if client:supports_method("textDocument/foldingRange") then
			setup_folding(buf)
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

-- Drop the highlight autocmds once no remaining client supports it
vim.api.nvim_create_autocmd("LspDetach", {
	group = vim.api.nvim_create_augroup("core_lsp_detach", { clear = true }),
	callback = function(args)
		vim.lsp.util.buf_clear_references(args.buf)
		if buf_supports(args.buf, "textDocument/documentHighlight", args.data.client_id) then
			return
		end
		pcall(vim.api.nvim_del_augroup_by_name, buf_group("highlight", args.buf))
	end,
})
