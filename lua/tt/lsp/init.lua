require("tt.nvim_utils")
local ui = require("tt.lsp.ui")
local maps = require("tt.lsp.mappings")
local efm = require("tt.lsp.efm")
local sumneko = require("tt.lsp.sumneko")

local M = {}

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

local border = {
      {"🭽", "FloatBorder"},
      {"▔", "FloatBorder"},
      {"🭾", "FloatBorder"},
      {"▕", "FloatBorder"},
      {"🭿", "FloatBorder"},
      {"▁", "FloatBorder"},
      {"🭼", "FloatBorder"},
      {"▏", "FloatBorder"},
}

-- LSP settings
local on_attach = function(client, bufnr)
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
end

function M.configureLSP()
	ui.autocompleteSymbols()
	ui.diagnosticSigns()
	maps.setMappings()
	local nvim_lsp = require("lspconfig")
	local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
	-- capabilities.textDocument.completion.completionItem.snippetSupport = true

	-- individual langserver setup
	efm.setup({on_attach = on_attach})
	sumneko.setup()

	nvim_lsp.html.setup({
    on_attach = on_attach,
		capabilities = capabilities,
		cmd = { get_node_bin("vscode-html-languageserver-bin"), "--stdio" },
	})
	nvim_lsp.tsserver.setup({
    on_attach = on_attach,
		capabilities = capabilities,
		cmd = { get_node_bin("typescript-language-server"), "--stdio" },
		commands = {
			OrganizeImports = {
				organize_imports,
				description = "Organize Imports",
			},
		},
	})
	nvim_lsp.rust_analyzer.setup({
    on_attach = on_attach,
		capabilities = capabilities,
		init_options = {
			documentFormatting = true,
		},
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
		cmd = { get_node_bin("bash-language-server"), "start" },
	})

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		underline = true,
		virtual_text = false,
		signs = true,
    border = border,
	})
end

return M
