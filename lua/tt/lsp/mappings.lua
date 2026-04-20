local M = {}

function M.setMappings(bufnr)
	vim.keymap.set("n", "ge", function()
		vim.diagnostic.open_float(0, { scope = "cursor" })
	end, { buffer = bufnr, desc = "Show diagnostic" })
	vim.keymap.set("n", "gs", function()
		vim.cmd.vsplit()
		vim.lsp.buf.definition()
	end, { buffer = bufnr, desc = "Go to definition (vsplit)" })
	vim.keymap.set("n", "<leader>t", vim.lsp.buf.workspace_symbol, { buffer = bufnr, desc = "Workspace Symbol" })
end

return M
