local ts_clients = { ts_ls = true, astro = true }
local ts_translator_setup = false
local group = vim.api.nvim_create_augroup("tt_lsp", { clear = true })
local progress = require("tt.lsp.progress")
local diagnostics = require("tt.lsp.diagnostics")

local function update_folds(buf)
	local folding = #vim.lsp.get_clients({ bufnr = buf, method = "textDocument/foldingRange" }) > 0
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		if require("tt.buffer").is_large(buf) then
			vim.wo[win][0].foldexpr = "0"
		elseif folding then
			vim.wo[win][0].foldexpr = vim.lsp.foldexpr
			vim.wo[win][0].foldtext = vim.lsp.foldtext
		elseif vim.wo[win][0].foldexpr == vim.lsp.foldexpr or vim.wo[win][0].foldexpr == "0" then
			vim.wo[win][0].foldexpr = vim.go.foldexpr
			vim.wo[win][0].foldtext = vim.go.foldtext
		end
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end
		local bufnr = args.buf

		if ts_clients[client.name] then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			if not ts_translator_setup then
				vim.cmd.packadd("ts-error-translator.nvim")
				require("ts-error-translator").setup()
				ts_translator_setup = true
			end
		end

		require("tt.lsp.mappings").setMappings(bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = false,
			convert = function(item)
				return { abbr = item.label:gsub("%b()", "") }
			end,
		})
		if client:supports_method("textDocument/codeLens", bufnr) then
			vim.lsp.codelens.enable(true, { bufnr = bufnr })
		end
		if client:supports_method("textDocument/onTypeFormatting", bufnr) then
			vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
		end
		if require("tt.buffer").is_large(bufnr) then
			vim.lsp.document_color.enable(false, { bufnr = bufnr })
		end
		update_folds(bufnr)
		progress.sync(bufnr)
		diagnostics.refresh(client.id)
		require("tt.nvim_utils").vim_util.refresh_lsp_clients(bufnr)
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = group,
	callback = function(args)
		progress.detach(args.data.client_id, args.buf)
		-- LspDetach runs before the client is removed from the buffer.
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(args.buf) then
				require("tt.nvim_utils").vim_util.refresh_lsp_clients(args.buf)
				update_folds(args.buf)
			end
		end)
	end,
})

vim.lsp.config("*", {
	root_markers = { ".git", "root_marker" },
})

vim.lsp.enable({
	"lua_ls",
	"zls",
	"rust_analyzer",
	"gopls",
	"marksman",
	"clangd",
	"html",
	"sqls",
	"biome",
	"bashls",
	"astro",
	"ts_ls",
	"efm",
})

vim.diagnostic.config({
	underline = false,
	virtual_text = false,
	jump = {
		on_jump = function()
			vim.diagnostic.open_float({ scope = "cursor" })
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

vim.api.nvim_create_autocmd("LspProgress", {
	group = group,
	callback = function(ev)
		progress.update(ev)
		diagnostics.on_progress(ev)
	end,
})
vim.api.nvim_create_autocmd("DiagnosticChanged", { group = group, callback = diagnostics.redraw })
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = group,
	callback = function(ev)
		update_folds(ev.buf)
	end,
})
