local M = {}

local function bufmap(mode, lhs, rhs, bufnr, desc)
	vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end

function M.setMappings(bufnr)
	bufmap("n", "ge", function()
		vim.diagnostic.open_float(0, { scope = "cursor" })
	end, bufnr, "Show diagnostic")
	bufmap("n", "gs", ":vsplit|lua vim.lsp.buf.definition()<CR>", bufnr, "Go to definition (vsplit)")
	bufmap("n", "<leader>t", vim.lsp.buf.workspace_symbol, bufnr, "Workspace Symbol")
end

return M
