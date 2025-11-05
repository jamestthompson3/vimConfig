local M = {}

local function bufmap(mode, lhs, rhs, bufnr)
	vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
end

function M.setMappings(bufnr)
	bufmap("n", "ge", function()
		vim.diagnostic.open_float(0, { scope = "cursor" })
	end, bufnr)
	bufmap("n", "gd", vim.lsp.buf.definition, bufnr)
	bufmap("n", "gs", ":vsplit|lua vim.lsp.buf.definition()<CR>", bufnr)
	bufmap("n", "<leader>k", vim.lsp.codelens.run, bufnr)
	bufmap("n", "<leader>i", vim.lsp.buf.implementation, bufnr)
	bufmap("n", "<leader>f", vim.lsp.buf.format, bufnr)
end

return M
