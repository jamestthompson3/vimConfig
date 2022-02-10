local vim_util = require("tt.nvim_utils").vim_util

local M = {}

function M.bootstrap()
  local autocmds = {
    rust = {
      {"BufWritePre", "<buffer>", "lua vim.lsp.buf.formatting_sync(nil, 1000)"},
    }
  }
  vim.api.nvim_command([[command! Check silent make! check]])
	vim_util.create_augroups(autocmds)
end

return M
