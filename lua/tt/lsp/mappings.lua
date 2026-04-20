local M = {}

local function bufmap(mode, lhs, rhs, bufnr, desc)
	vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end

function M.setMappings(bufnr)
	bufmap("n", "ge", function()
		vim.diagnostic.open_float(0, { scope = "cursor" })
	end, bufnr, "Show diagnostic")
	bufmap("n", "gs", function()
		vim.cmd.vsplit()
		vim.lsp.buf.definition()
	end, bufnr, "Go to definition (vsplit)")
	bufmap("n", "<leader>t", vim.lsp.buf.workspace_symbol, bufnr, "Workspace Symbol")
end

return M
