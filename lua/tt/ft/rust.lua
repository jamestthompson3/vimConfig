require("tt.nvim_utils")

local M = {}

function M.bootstrap()
	local mappings = {
		["i<C-l>"] = { 'println!("{}")<esc>i', noremap = true, buffer = true },
	}

	vim.compiler = "cargo"
  vim.api.nvim_command [[set makeprg=cargo\ check]]
  vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]

	nvim_apply_mappings(mappings, { silent = true })
end

return M
