local buf_nnoremap = require("tt.nvim_utils").keys.buf_nnoremap

local M = {}

local function bufmap(rhs, lhs, bufnr)
	buf_nnoremap({ rhs, lhs, { buffer = bufnr } })
end
function M.setMappings(bufnr)
	bufmap("ge", function()
		vim.diagnostic.open_float(0, { scope = "cursor" })
	end, bufnr)
	bufmap("gd", vim.lsp.buf.definition, bufnr)
	bufmap("gt", vim.lsp.buf.type_definition, bufnr)
	bufmap("K", vim.lsp.buf.hover, bufnr)
	bufmap("[e", vim.diagnostic.goto_next, bufnr)
	bufmap("]e", vim.diagnostic.goto_prev, bufnr)
	bufmap("ga", vim.lsp.buf.code_action, bufnr)
	bufmap("gs", "vsplit|lua vim.lsp.buf.definition", bufnr)
	bufmap("<leader>r", vim.lsp.buf.references, bufnr)
	bufmap("<leader>i", vim.lsp.buf.implementation, bufnr)
	bufmap("<leader>f", vim.lsp.buf.formatting, bufnr)
	bufmap("<leader>n", vim.lsp.buf.rename, bufnr)
end

return M
