local M = {}

local function bufmap(mode, lhs, rhs, bufnr, desc)
	vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end

function M.setMappings(bufnr)
	bufmap("n", "ge", function()
		vim.diagnostic.open_float(0, { scope = "cursor" })
	end, bufnr, "Show diagnostic")
	bufmap("n", "gd", vim.lsp.buf.definition, bufnr, "Go to definition")
	bufmap("n", "gs", ":vsplit|lua vim.lsp.buf.definition()<CR>", bufnr, "Go to definition (vsplit)")
	bufmap("n", "<leader>k", vim.lsp.codelens.run, bufnr, "Run codelens")
	bufmap("n", "<leader>i", vim.lsp.buf.implementation, bufnr, "Go to implementation")
	bufmap("n", "<leader>f", vim.lsp.buf.format, bufnr, "Format buffer")
	bufmap("n", "<leader>th", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
	end, bufnr, "Toggle inlay hints")
end

return M
