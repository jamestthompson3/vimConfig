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
    ["nga"]        = map_cmd [[lua require'telescope.builtin'.lsp_code_actions()]]
  }
  nvim_apply_mappings(mappings, {silent = true})
end

function M.configureLSP()
  local nvim_lsp = require 'lspconfig'
  local util = nvim_lsp.util
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

  nvim_lsp.cssls.setup({})
  nvim_lsp.tsserver.setup({
    capabilities = capabilities
  })
  nvim_lsp.rust_analyzer.setup{
    capabilities = capabilities
  }
  nvim_lsp.diagnosticls.setup ({
    filetypes = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_dir = function(fname)
      return util.root_pattern(".git")(fname)
    end,
    init_options = {
      linters = {
        eslint = {
          command = "node_modules/.bin/eslint",
          rootPatterns = {".eslintrc.cjs", ".eslintrc", ".eslintrc.json", ".eslintrc.js", ".git"},
          debounce = 100,
          args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
          sourceName = "eslint",
          parseJson = {
            errorsRoot = "[0].messages",
            line = "line",
            column = "column",
            endLine = "endLine",
            endColumn = "endColumn",
            message = "[eslint] ${message} [${ruleId}]",
            security = "severity",
          },
          securities = {[2] = "error", [1] = "warning"},
        },
      },
      filetypes = {
        javascript = "eslint",
        javascriptreact = "eslint",
        typescript = "eslint",
        typescriptreact = "eslint",
        ["typescript.tsx"] = "eslint",
      },
    },
  })

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
