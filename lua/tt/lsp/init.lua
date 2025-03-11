local node = require("tt.nvim_utils").nodejs
local ui = require("tt.lsp.ui")
local efm = require("tt.lsp.efm")
local border = ui.border

local initialized = false

if initialized then
	return
end

-- LSP settings
local on_attach = function(_, bufnr)
	require("tt.lsp.mappings").setMappings(bufnr)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border })
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
	virtual_text = false,
	signs = true,
	border,
})
vim.diagnostic.config({ jump = { float = true } })
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
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.semanticTokens.multilineTokenSupport = true
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
vim.lsp.config("*", {
	root_markers = { ".git", "root_marker" },
	capabilities = capabilities,
})

-- individual langserver setup
vim.lsp.config.lua_ls = {
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
	},
	filetypes = { "lua" },
	on_attach = on_attach,
	cmd = { "lua-language-server" },
}
vim.lsp.config.sqls = {
	cmd = { "sqls" },
	filetypes = { "sql", "mysql" },
	on_attach = function(client, bufnr)
		require("sqls").on_aa_attach(client, bufnr)
	end,
}
vim.lsp.config.html = {
	filetypes = { "html", "templ" },
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
	end,
	init_options = {
		documentFormatting = false,
	},
	cmd = { node.get_node_bin("html-languageserver"), "--stdio" },
}
-- vim.lsp.config.css.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	cmd = { node.get_node_bin("css-languageserver"), "--stdio" },
-- })
--
vim.lsp.config.biome = {
	cmd = { node.get_node_bin("biome"), "lsp-proxy" },
	root_markers = {
		"biome.json",
		"biome.jsonc",
	},
	filetypes = {
		"astro",
		"css",
		"graphql",
		"javascript",
		"javascriptreact",
		"json",
		"jsonc",
		"svelte",
		"typescript",
		"typescript.tsx",
		"typescriptreact",
		"vue",
	},
	on_attach = function(_, bufnr)
		if vim.g.autoformat == true then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							return client.name ~= "ts_ls"
						end,
					})
				end,
			})
		end
	end,
}
vim.lsp.config.rust_analyzer = {
	on_attach = on_attach,
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	-- init_options = {
	-- 	documentFormatting = true,
	-- },
	checkOnSave = {
		enabled = true,
		command = "clippy",
	},
}
vim.lsp.config.gopls = {
	filetypes = { "go" },
	cmd = { "gopls", "serve" },
	on_attach = function(_, bufnr)
		if vim.g.autoformat == true then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format()
				end,
			})
		end
	end,
	analyses = {
		unusedparams = true,
		staticcheck = true,
	},
}

vim.lsp.config.bashls = {
	on_attach = on_attach,
	cmd = { node.get_node_bin("bash-language-server"), "start" },
}

vim.lsp.config.clangd = {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	on_attach = on_attach,
}

vim.lsp.config.ts_ls = {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
		on_attach(client, bufnr)
	end,
	capabilities = capabilities,
	cmd = { node.find_node_executable("typescript-language-server"), "--stdio" },
	init_options = { hostInfo = "neovim" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	single_file_support = true,
}

vim.lsp.config.ctags_lsp = {
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	cmd = { "ctags-lsp" },
	on_attach = on_attach,
}
efm.setup()
vim.lsp.enable({
	"ts_ls",
	"bashls",
	"gopls",
	"rust_analyzer",
	"clangd",
	"sqls",
	"html",
	"lua_ls",
	"ctags_lsp",
})

initialized = true
