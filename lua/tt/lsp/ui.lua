local M = {}
local fmt = string.format

function M.diagnosticSigns()
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "❌",
        [vim.diagnostic.severity.WARN]  = "",
        [vim.diagnostic.severity.INFO]  = "",
        [vim.diagnostic.severity.HINT]  = "",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticError",
        [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
        [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
        [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
      }
    }
  })
end

return M
