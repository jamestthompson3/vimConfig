require("tt.user_lsp").setMappings()
require("tt.nvim_utils")

local M = {}

function M.bootstrap()
	local mappings = {
		["i<C-l>"] = { 'println!("{}")<esc>i', noremap = true, buffer = true },
	}

	vim.compiler = "cargo"
	local autocmds = {
		rust = {
			{ "BufWritePre lua vim.lsp.buf.formatting_sync()" },
		},
	}
	nvim_create_augroups(autocmds)

	nvim_apply_mappings(mappings, { silent = true })
end

return M
