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
    ["n[e"]        = map_cmd [[lua vim.lsp.diagnostic.goto_next()]],
    ["n]e"]        = map_cmd [[lua vim.lsp.diagnostic.goto_prev()]],
    ["n<leader>r"] = map_cmd [[lua vim.lsp.buf.references()]],
    ["n<leader>f"] = map_cmd [[lua vim.lsp.buf.formatting()]],
    ["n<leader>n"] = map_cmd [[lua vim.lsp.buf.rename()]],
    ["n<leader>l"] = map_cmd [[lua vim.lsp.util.show_line_diagnostics()]],
    ["nga"]        = map_cmd [[lua require'telescope.builtin'.lsp_code_actions()]]
  }
  nvim_apply_mappings(mappings, {silent = true})
end

local eslint = {
  lintCommand = string.format('%s --stdin --stdin-filename ${INPUT} --format unix', get_node_bin('eslint_d')),
  lintSource = "eslint",
  lintStdin = true,
  rootMarkers = {
    '.eslintrc.js';
    '.eslintrc.cjs';
    '.eslintrc.yaml';
    '.eslintrc.yml';
    '.eslintrc.json';
    '.git';
    'package.json';
  },
  lintFormats = {'%f:%l:%c: %m'}
}

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

local prettier = {
  formatCommand = ([[
  ./node_modules/.bin/prettier
  ${--config-precedence:configPrecedence}
  ${--tab-width:tabWidth}
  ${--single-quote:singleQuote}
  ${--trailing-comma:trailingComma}
  ]]):gsub(
  "\n",
  ""
  )
}

function M.configureLSP()
  local nvim_lsp = require 'lspconfig'
  local util = nvim_lsp.util
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  nvim_lsp.cssls.setup({})
  nvim_lsp.tsserver.setup({
    capabilities = capabilities,
    init_options = {
      documentFormatting = false
    }
  })
  nvim_lsp.rust_analyzer.setup{
    capabilities = capabilities
  }
  nvim_lsp.efm.setup {
    init_options = {documentFormatting = false},
    settings = {
      languages = {
        javascript = {eslint},
        javascriptreact = {eslint},
        ["javascript.jsx"] = {eslint},
        typescript = {eslint},
        ["typescript.tsx"] = {eslint},
        typescriptreact = {eslint}
      }
    },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescript.tsx",
      "typescriptreact"
    },
  }
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
