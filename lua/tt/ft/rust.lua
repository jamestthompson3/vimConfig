require("tt.nvim_utils")

local M = {}

function M.bootstrap()
	local mappings = {
		["i<C-l>"] = { 'println!("")<esc>i<left>', noremap = true, buffer = true },
	}

  local autocmds = {
    rust = {
      {"BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync(nil, 1000)"},
    }
  }
  vim.api.nvim_command([[command! Check silent make! check]])
	nvim_create_augroups(autocmds)
	nvim_apply_mappings(mappings, { silent = true })
end

return M
