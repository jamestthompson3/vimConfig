local M = {}
local all_buffer_diagnostics = {}
local api = vim.api
local util = vim.lsp.util
local protocol = require 'vim.lsp.protocol'
local validate = vim.validate

local severity_highlights = {
  [protocol.DiagnosticSeverity.Error] = 'LspDiagnosticsError';
  [protocol.DiagnosticSeverity.Warning] = 'LspDiagnosticsWarning';
  [protocol.DiagnosticSeverity.Information] = 'LspDiagnosticsInformation';
  [protocol.DiagnosticSeverity.Hint] = 'LspDiagnosticsHint';
}

function M.buf_diagnostics_save_positions(bufnr, diagnostics)
  validate {
    bufnr = {bufnr, 'n', true};
    diagnostics = {diagnostics, 't', true};
  }
  if not diagnostics then return end
  bufnr = bufnr == 0 and api.nvim_get_current_buf() or bufnr

  if not all_buffer_diagnostics[bufnr] then
    -- Clean up our data when the buffer unloads.
    api.nvim_buf_attach(bufnr, false, {
      on_detach = function(b)
        all_buffer_diagnostics[b] = nil
      end
    })
  end
  all_buffer_diagnostics[bufnr] = {}
  local buffer_diagnostics = all_buffer_diagnostics[bufnr]

  for _, diagnostic in ipairs(diagnostics) do
    local start = diagnostic.range.start
    local line_diagnostics = buffer_diagnostics[start.line]
    if not line_diagnostics then
      line_diagnostics = {}
      buffer_diagnostics[start.line] = line_diagnostics
    end
    table.insert(line_diagnostics, diagnostic)
  end
end

function M.buf_diagnostics_set_signs(_, _, result)
  if not result then return end
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)

  if not bufnr then
    err_message("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
    return
  end

  util.buf_clear_diagnostics(bufnr)
  util.buf_diagnostics_save_positions(bufnr, result.diagnostics)

  M.buf_diagnostics_save_positions(bufnr, result.diagnostics)
  local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]

  local file = api.nvim_exec("echo expand('%:p')")
  local unplace = string.format('sign unplace * group=lsp_diag file=%s', file)
  -- clean up exiting signs
  api.nvim_command(unplace)
  for line, line_diags in pairs(buffer_line_diagnostics) do
    for _, val in pairs(line_diags) do
      if not val then
        return
      end
      api.nvim_command(string.format('sign define lsp text=◉  texthl=%s', severity_highlights[val.severity]))
      for _, l in pairs(val.range) do
        local line_no = l.line + 1
        -- still errors out sometimes with invalid filename
        local sign_place = string.format('sign place %d line=%d name=lsp group=lsp_diag file=%s', line_no, line_no, file)
        api.nvim_command(sign_place)
      end
    end
  end
end

return M
