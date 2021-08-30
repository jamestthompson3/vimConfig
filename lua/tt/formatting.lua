-- Taken from fsouza's dotfiles mostly
local M = { fns = {} }
local fn = vim.fn
local api = vim.api

local function rewrite_wrap(cb)
	local bufnr = api.nvim_get_current_buf()

	local cursor = api.nvim_win_get_cursor(0)
	local orig_lineno, orig_colno = cursor[1], cursor[2]
	local orig_line = api.nvim_buf_get_lines(bufnr, orig_lineno - 1, orig_lineno, true)[1]
	local orig_nlines = api.nvim_buf_line_count(bufnr)
	local view = fn.winsaveview()

	cb()

	-- note: this isn't 100% correct, if the lines change below the current one,
	-- the position won't be the same, but this is optmistic: if the file was
	-- already formatted before, the lines below will mostly do the right thing.
	local line_offset = api.nvim_buf_line_count(bufnr) - orig_nlines
	local lineno = orig_lineno + line_offset
	local col_offset = string.len(api.nvim_buf_get_lines(bufnr, lineno - 1, lineno, true)[1] or "")
		- string.len(orig_line)
	view.lnum = lineno
	view.col = orig_colno + col_offset
	fn.winrestview(view)
end

local function fmt_buf(client, bufnr, cb)
	local util = vim.lsp.util
	local _, req_id = client.request("textDocument/formatting", util.make_formatting_params(), cb, bufnr)
	return req_id, function()
		client.cancel_request(req_id)
	end
end

local function autofmt(client, bufnr)
	local util = vim.lsp.util
	pcall(function()
		local changed_tick = api.nvim_buf_get_changedtick(bufnr)
		fmt_buf(client, bufnr, function(_, _, result, _)
			if changed_tick ~= api.nvim_buf_get_changedtick(bufnr) then
				return
			end
			if result then
				api.nvim_buf_call(bufnr, function()
					rewrite_wrap(function()
						util.apply_text_edits(result, bufnr)
					end)
					vim.cmd("update")
				end)
			end
		end)
	end)
end

function M.format_on_save(bufnr, format_client)
	local client = M.select_client("textDocument/formatting", format_client)
	if client == nil then
		return
	end
	autofmt(client, bufnr)
end

function M.fmt_on_attach(client, bufnr)
	augroup("autoformatting_" .. bufnr, {
		{
			events = { "BufWritePost" },
			targets = { string.format("<buffer=%d>", bufnr) },
			command = M.fn_cmd(function()
				M.format_on_save(bufnr, client.name) --string.format("lua require'tt.formatting'.format_on_save(%d, %s)", bufnr, client.name),
			end),
		},
	})
end

function M.select_client(method, name)
	local clients = vim.tbl_values(vim.lsp.buf_get_clients())
	clients = vim.tbl_filter(function(client)
		return client.supports_method(method)
	end, clients)

	for i = 1, #clients do
		if clients[i].name == name then
			return clients[i]
		end
	end

	return nil
end

local function register_cb(cb)
	local id = tostring(cb)
	M.fns[id] = cb
	return id
end

function M.fn_cmd(cb)
	local id = register_cb(cb)
	return string.format([[lua require('tt.formatting').fns['%s']()]], id)
end

return M
