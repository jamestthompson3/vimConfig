local M = {}

function M.setMappings(bufnr)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buf = bufnr, desc = "Go to definition" })
	vim.keymap.set("n", "ge", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, { buf = bufnr, desc = "Show diagnostic" })
	vim.keymap.set("n", "gs", function()
		vim.cmd.vsplit()
		vim.lsp.buf.definition()
	end, { buf = bufnr, desc = "Go to definition (vsplit)" })
	vim.keymap.set("n", "<leader>t", vim.lsp.buf.workspace_symbol, { buf = bufnr, desc = "Workspace Symbol" })
end

return M
