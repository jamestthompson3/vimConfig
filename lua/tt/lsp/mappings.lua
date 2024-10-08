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
	bufmap("gs", ":vsplit|lua vim.lsp.buf.definition()<CR>", bufnr)
  bufmap("<leader>k", vim.lsp.codelens.run)
	bufmap("<leader>i", vim.lsp.buf.implementation, bufnr)
	bufmap("<leader>f", vim.lsp.buf.format, bufnr)
end

return M
