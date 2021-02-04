local util = require 'vim.lsp.util'
require('tt.nvim_utils')

local M = {}

if not sign_defined then
  vim.fn.sign_define('LspDiagnosticsSignError', {text='💥', texthl='LspDiagnosticsSignError', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsSignWarning', {text='◉', texthl='LspDiagnosticsSignWarning', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsSignInfo', {text='🙃', texthl='LspDiagnosticsSignInfo', linehl='', numhl=''})
  vim.fn.sign_define('LspDiagnosticsSignHint', {text='💡', texthl='LspDiagnosticsSignHint', linehl='', numhl=''})
  sign_defined = true
end

function M.setMappings()
  local mappings = {
    ["nge"]        = map_cmd [[lua vim.lsp.diagnostic.show_line_diagnostics()]],
    ["ngd"]        = map_cmd [[lua vim.lsp.buf.definition()]],
    ["ngh"]        = map_cmd [[lua vim.lsp.buf.hover()]],
    ["n[d"]        = map_cmd [[NextDiagnostic]],
    ["n]d"]        = map_cmd [[PrevDiagnostic]],
    ["n<leader>r"] = map_cmd [[lua vim.lsp.buf.references()]],
    ["n<leader>f"] = map_cmd [[lua vim.lsp.buf.formatting()]],
    ["n<leader>n"] = map_cmd [[lua vim.lsp.buf.rename()]],
    ["nga"]        = map_cmd [[lua require'telescope.builtin'.lsp_code_actions()]]
  }
  nvim_apply_mappings(mappings, {silent = true})
end

function M.configureLSP()
  local nvim_lsp = require 'lspconfig'
  -- nvim_lsp.sumneko_lua.setup({})
  nvim_lsp.cssls.setup({})
  nvim_lsp.tsserver.setup({})
  -- nvim_lsp.efm.setup({})
  nvim_lsp.rust_analyzer.setup{}
  nvim_lsp.bashls.setup({})

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
  }
  )

end

return M
