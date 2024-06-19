local node = require("tt.nvim_utils").nodejs
local ui = require("tt.lsp.ui")
local efm = require("tt.lsp.efm")

local M = {}

local function on_exit(obj)
  vim.schedule_wrap(function()
    vim.cmd("update")
  end)
end

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

local border = {
  { "🭽", "FloatBorder" },
  { "▔", "FloatBorder" },
  { "🭾", "FloatBorder" },
  { "▕", "FloatBorder" },
  { "🭿", "FloatBorder" },
  { "▁", "FloatBorder" },
  { "🭼", "FloatBorder" },
  { "▏", "FloatBorder" },
}

-- LSP settings
local on_attach = function(_, bufnr)
  require("tt.lsp.mappings").setMappings(bufnr)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
  -- vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
  -- 	buffer = 0,
  -- 	desc = "refresh code lens",
  -- 	callback = vim.lsp.codelens.refresh,
  -- })
end

function M.configureLSP()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.server_capabilities.definitionProvider then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
      end
    end,
  })

  ui.diagnosticSigns()
  local nvim_lsp = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- local present = pcall(require, "cmp_nvim_lsp")
  -- if not present then
  -- 	return
  -- end

  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
  --
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- individual langserver setup

  nvim_lsp.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
  nvim_lsp.html.setup({
    on_attach = function(client, bufnr)
      if vim.g.autoformat == true then
        vim.api.nvim_create_autocmd("BufWritePost", {
          buffer = bufnr,
          callback = function()
            vim.system({
              require("tt.nvim_utils").nodejs.find_node_executable("prettier"),
              "--parser",
              "html",
              "--write",
              vim.fn.expand("%"),
            }, { text = true }):wait()
            vim.cmd("update")
          end,
        })
      end
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    init_options = {
      documentFormatting = false,
    },
    cmd = { node.get_node_bin("html-languageserver"), "--stdio" },
  })
  -- nvim_lsp.css.setup({
  -- 	on_attach = on_attach,
  -- 	capabilities = capabilities,
  -- 	cmd = { node.get_node_bin("css-languageserver"), "--stdio" },
  -- })
  nvim_lsp.biome.setup {
    cmd = { node.get_node_bin("biome"), "lsp-proxy" },
    on_attach = function(client, bufnr)
      if vim.g.autoformat == true then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              filter = function(client) return client.name ~= "tsserver" end
            })
            -- vim.system({
            --   require("tt.nvim_utils").nodejs.find_node_executable("biome"),
            --   "format",
            --   "--write",
            --   vim.fn.expand("%"),
            -- }, { text = true }, on_exit)
          end,
        })
      end
    end,
  }
  nvim_lsp.tsserver.setup({
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    cmd = { node.find_node_executable("typescript-language-server"), "--stdio" },
  })
  nvim_lsp.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    -- init_options = {
    -- 	documentFormatting = true,
    -- },
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          enabled = true,
          command = "clippy",
        },
      },
    },
  })
  nvim_lsp.gopls.setup({
    on_attach = on_attach,
    cmd = { "gopls", "serve" },
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  })

  nvim_lsp.bashls.setup({
    on_attach = on_attach,
    cmd = { node.get_node_bin("bash-language-server"), "start" },
  })

  nvim_lsp.clangd.setup({
    on_attach = on_attach,
  })

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = false,
    virtual_text = false,
    signs = true,
    border = border,
  })
  -- efm.setup()
  -- Start Lsp immediately after config
  vim.api.nvim_command("LspStart")
end

return M
