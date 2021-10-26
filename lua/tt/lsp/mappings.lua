local M = {}
require("tt.nvim_utils")

function M.setMappings()
	local mappings = {
		["nge"] = map_cmd([[lua vim.diagnostic.open_float(0, { scope = "cursor" })]]),
		["ngd"] = map_cmd([[lua vim.lsp.buf.definition()]]),
		["nK"] = map_cmd([[lua vim.lsp.buf.hover()]]),
		["n[e"] = map_cmd([[lua vim.diagnostic.goto_next()]]),
		["n]e"] = map_cmd([[lua vim.diagnostic.goto_prev()]]),
		["nga"] = map_cmd([[lua vim.lsp.buf.code_action()]]),
		["ngs"] = map_cmd([[vsplit|lua vim.lsp.buf.definition()]]),
		["n<leader>r"] = map_cmd([[lua vim.lsp.buf.references()]]),
		["n<leader>f"] = map_cmd([[lua vim.lsp.buf.formatting()]]),
		["n<leader>n"] = map_cmd([[lua vim.lsp.buf.rename()]]),
	}
	nvim_apply_mappings(mappings, { silent = true })
end

return M
