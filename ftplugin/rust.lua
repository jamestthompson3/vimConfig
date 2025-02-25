local vim_util = require("tt.nvim_utils").vim_util

local M = {}

function M.bootstrap()
  vim.lsp.start(vim.lsp.config.efm)
  local autocmds = {
    rust = {
      {
        "BufWritePost",
        {
          pattern = ".rs",
          buffer = true,
          callback = function()
            vim.lsp.buf.formatting_sync(nil, 500)
          end,
        },
      },
    },
  }
  vim.api.nvim_command([[command! Check silent make! check]])
  vim_util.create_augroups(autocmds)
end

return M
