local M = {}
local supported = {
	c = true,
	cpp = true,
	css = true,
	scss = true,
	html = true,
	javascript = true,
	javascriptreact = true,
	typescript = true,
	typescriptreact = true,
	lua = true,
}
local attached = {}

function M.update(buf)
	if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
		return
	end
	local enabled = supported[vim.bo[buf].filetype] and not require("tt.buffer").is_large(buf)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, method = "textDocument/documentColor" })) do
		if vim.lsp.document_color.is_enabled({ bufnr = buf, client_id = client.id }) then
			enabled = false
			break
		end
	end
	local colorizer = require("colorizer")
	if enabled and not attached[buf] then
		colorizer.attach_to_buffer(buf)
		attached[buf] = true
	elseif not enabled and attached[buf] then
		colorizer.detach_from_buffer(buf)
		attached[buf] = nil
	end
end

function M.setup()
	require("colorizer").setup({
		filetypes = { "*" },
		buftypes = {},
		options = { parsers = { css = true }, display = { disable_document_color = false } },
	})
	-- The plugin callbacks do not use the size and LSP checks in M.update.
	vim.api.nvim_clear_autocmds({ group = "ColorizerSetup", event = { "FileType", "BufWinEnter" } })
	local group = vim.api.nvim_create_augroup("tt_colorizer", { clear = true })
	vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter", "TextChanged", "TextChangedI", "LspAttach" }, {
		group = group,
		callback = function(ev)
			M.update(ev.buf)
		end,
	})
	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		callback = function(ev)
			vim.schedule(function()
				M.update(ev.buf)
			end)
		end,
	})
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		callback = function(ev)
			attached[ev.buf] = nil
		end,
	})
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		M.update(buf)
	end
end

return M
