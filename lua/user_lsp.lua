local util = require 'vim.lsp.util'
local protocol = require 'vim.lsp.protocol'
require('nvim_utils')

local M = {}
local lsps_diagnostics = {}
local all_buffer_diagnostics = {}
local api = vim.api
local validate = vim.validate

local severity_highlights = {
  [protocol.DiagnosticSeverity.Error] = 'LspDiagnosticsError';
  [protocol.DiagnosticSeverity.Warning] = 'LspDiagnosticsWarning';
  [protocol.DiagnosticSeverity.Information] = 'LspDiagnosticsInformation';
  [protocol.DiagnosticSeverity.Hint] = 'LspDiagnosticsHint';
}


function M.buf_clear_diagnostics(bufnr)
  validate { bufnr = {bufnr, 'n', true} }
  bufnr = bufnr == 0 and api.nvim_get_current_buf() or bufnr

  -- clear signs
  vim.fn.sign_unplace('nvim-lsp', {buffer=bufnr})

  -- clear virtual text namespace
  api.nvim_buf_clear_namespace(bufnr, 2, 0, -1)
end

function M.buf_diagnostics_virtual_text(bufnr, diagnostics)
  -- return if we are called from a window that is not showing bufnr
  if api.nvim_win_get_buf(0) ~= bufnr then return end

  local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
  if not buffer_line_diagnostics then
    util.buf_diagnostics_save_positions(bufnr, diagnostics)
  end
  buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
  if not buffer_line_diagnostics then
    return
  end
  local line_no = api.nvim_buf_line_count(bufnr)
  for _, line_diags in pairs(buffer_line_diagnostics) do

    line = line_diags[1].range.start.line
    if line+1 > line_no then goto continue end

    local virt_texts = {}

    -- window total width
    local win_width = api.nvim_win_get_width(0)

    -- line length
    local lines = api.nvim_buf_get_lines(bufnr, line, line+1, 0)
    local line_width = 0
    if table.getn(lines) > 0 then
      local line_content = lines[1]
      if line_content == nil then goto continue end
      line_width = vim.fn.strdisplaywidth(line_content)
    end

    -- window decoration with (sign + fold + number)
    local decoration_width = window_decoration_columns()

    -- available space for virtual text
    local right_padding = 1
    local available_space = win_width - decoration_width - line_width - right_padding

    -- virtual text
    local last = line_diags[#line_diags]
    local message = last.message:gsub("\r", ""):gsub("\n", "  ")

    -- more than one diagnostic in line
    if #line_diags > 1 then
      local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
      local prefix = string.rep(" ", leading_space)
      table.insert(virt_texts, {prefix, severity_highlights[line_diags[1].severity]})
      for i = 2, #line_diags - 1 do
        table.insert(virt_texts, {'', severity_highlights[line_diags[i].severity]})
      end
      table.insert(virt_texts, {message, severity_highlights[last.severity]})
      -- 1 diagnostic in line
    else
      local leading_space = available_space - vim.fn.strdisplaywidth(message) - #line_diags
      local prefix = string.rep(" ", leading_space)
      table.insert(virt_texts, {prefix..message, severity_highlights[last.severity]})
    end
    api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_texts, {})
    ::continue::
  end
end

-- show diagnostics in sign column
function M.buf_diagnostics_signs(bufnr, diagnostics)
  for _, diagnostic in ipairs(diagnostics) do
    -- errors
    if diagnostic.severity == 1 then
      vim.fn.sign_place(0, 'nvim-lsp', 'LspErrorSign', bufnr, {lnum=(diagnostic.range.start.line+1)})
      -- warnings
    elseif diagnostic.severity == 2 then
      vim.fn.sign_place(0, 'nvim-lsp', 'LspWarningSign', bufnr, {lnum=(diagnostic.range.start.line+1)})
      -- info
    elseif diagnostic.severity == 3 then
      vim.fn.sign_place(0, 'nvim-lsp', 'LspInfoSign', bufnr, {lnum=(diagnostic.range.start.line+1)})
      -- hint
    elseif diagnostic.severity == 4 then
      vim.fn.sign_place(0, 'nvim-lsp', 'LspHintSign', bufnr, {lnum=(diagnostic.range.start.line+1)})
    end
  end
end

-- show diagnostics in a number of ways
function M.buf_show_diagnostics(bufnr)
  if not lsps_diagnostics[bufnr] then return end
  M.buf_clear_diagnostics(bufnr)
  util.buf_diagnostics_save_positions(bufnr, lsps_diagnostics[bufnr])
  M.buf_diagnostics_virtual_text(bufnr, lsps_diagnostics[bufnr])
  M.buf_diagnostics_signs(bufnr, lsps_diagnostics[bufnr])
end

function M.diagnostics_callback(_, _, result)
  if not result then return end
  local uri = result.uri
  local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
  if not bufnr then
    api.nvim_err_writeln(string.format("LSP.publishDiagnostics: Couldn't find buffer for %s", uri))
    return
  end
  lsps_diagnostics[bufnr] = result.diagnostics
  M.buf_show_diagnostics(bufnr)
  -- util.buf_diagnostics_underline(bufnr, result.diagnostics)
end

if not sign_defined then
  vim.fn.sign_define('LspErrorSign', {text='X', texthl='LspDiagnosticsError', linehl='', numhl=''})
  vim.fn.sign_define('LspWarningSign', {text='◉', texthl='LspDiagnosticsWarning', linehl='', numhl=''})
  vim.fn.sign_define('LspInfoSign', {text='i', texthl='LspDiagnosticsInfo', linehl='', numhl=''})
  vim.fn.sign_define('LspHintSign', {text='H', texthl='LspDiagnosticsHint', linehl='', numhl=''})
  sign_defined = true
end

function M.setMappings()
  local mappings = {
    ["nge"]        = map_cmd [[lua vim.lsp.util.show_line_diagnostics()]],
    ["ngd"]        = map_cmd [[lua vim.lsp.buf.definition()]],
    ["ngh"]        = map_cmd [[lua vim.lsp.buf.hover()]],
    ["n[d"]        = map_cmd [[NextDiagnostic]],
    ["n]d"]        = map_cmd [[PrevDiagnostic]],
    ["ngr"]        = map_cmd [[lua vim.lsp.buf.references()]],
    ["n<leader>f"] = map_cmd [[lua vim.lsp.buf.formatting()]],
    ["n<leader>r"] = map_cmd [[lua vim.lsp.buf.rename()]]
  }
  nvim_apply_mappings(mappings, {silent = true})
end

return M
