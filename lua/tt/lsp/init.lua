local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.semanticTokens.multilineTokenSupport = true

local ts_clients = { ts_ls = true, astro = true }

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		local bufnr = args.buf

		if ts_clients[client.name] then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			require("ts-error-translator").setup()
		end

		require("tt.lsp.mappings").setMappings(bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = false,
			convert = function(item)
				return { abbr = item.label:gsub("%b()", "") }
			end,
		})
		if client.server_capabilities.codeLensProvider then
			vim.lsp.codelens.enable(true, { bufnr = bufnr })
		end
		if client.server_capabilities.documentOnTypeFormattingProvider then
			vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
		end
		if client.server_capabilities.colorProvider then
			vim.lsp.document_color.enable(true, { bufnr = bufnr })
		end
	end,
})

vim.lsp.config("*", {
	root_markers = { ".git", "root_marker" },
	capabilities = capabilities,
})

vim.lsp.enable({
	"lua_ls",
	"zls",
	"rust_analyzer",
	"gopls",
	"clangd",
	"html",
	"sqls",
	"biome",
	"bashls",
	"astro",
	"ts_ls",
})

vim.diagnostic.config({
	underline = false,
	virtual_text = false,
	jump = {
		on_jump = function(diagnostics, bufnr)
			vim.diagnostic.open_float({
				bufnr,
				namespace = diagnostics.namespace,
				severity = diagnostics.severity,
			})
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "●",
			[vim.diagnostic.severity.WARN] = "●",
			[vim.diagnostic.severity.INFO] = "●",
			[vim.diagnostic.severity.HINT] = "●",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticError",
			[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		},
	},
})

-- Set buffer busy status during LSP progress
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(args)
		local value = args.data.params.value
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		if value.kind == "begin" or value.kind == "report" then
			for bufnr in pairs(client.attached_buffers) do
				vim.bo[bufnr].busy = 1
			end
		elseif value.kind == "end" then
			for bufnr in pairs(client.attached_buffers) do
				vim.bo[bufnr].busy = 0
			end
		end
	end,
})

-- When server finishes progress (e.g., lua_ls finishes indexing), request diagnostics
vim.api.nvim_create_autocmd("LspProgress", {
	pattern = "end",
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		for bufnr in pairs(client.attached_buffers) do
			if client:supports_method("textDocument/diagnostic") then
				vim.lsp.diagnostic._refresh(bufnr, client.id)
			else
				if client:supports_method("textDocument/didOpen") then
					client:notify("textDocument/didOpen", {
						textDocument = {
							uri = vim.uri_from_bufnr(bufnr),
							languageId = vim.bo[bufnr].filetype,
							version = vim.lsp.util.buf_versions[bufnr] or 0,
							text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n"),
						},
					})
				end
			end
		end
	end,
})

-- Force sign column redraw when diagnostics change
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function(args)
		vim.api.nvim__redraw({ buf = args.buf, valid = false, statuscolumn = true })
	end,
})
