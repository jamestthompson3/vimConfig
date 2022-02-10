require("tt.nvim_utils")

local M = {}

function M.bootstrap()
  local autocmds = {
    rust = {
      {"BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync(nil, 1000)"},
    }
  }
  vim.api.nvim_command([[command! Check silent make! check]])
	nvim_create_augroups(autocmds)
end

return M
