local M = {}
local pending = {}

-- LuaLS 3.19.2 does not advertise pull support. Do not request diagnostics from it.
function M.refresh(client_id)
	local client = vim.lsp.get_client_by_id(client_id)
	if not client or client.name ~= "lua_ls" or pending[client_id] then
		return
	end
	pending[client_id] = true
	vim.defer_fn(function()
		pending[client_id] = nil
		if vim.lsp.get_client_by_id(client_id) ~= client then
			return
		end
		for buf in pairs(client.attached_buffers) do
			if
				vim.api.nvim_buf_is_valid(buf)
				and vim.api.nvim_buf_is_loaded(buf)
				and client:supports_method("textDocument/diagnostic", buf)
			then
				local provider = client.server_capabilities.diagnosticProvider
				client:request("textDocument/diagnostic", {
					textDocument = { uri = vim.uri.from_buf(buf) },
					identifier = type(provider) == "table" and provider.identifier or nil,
				}, nil, buf)
			end
		end
	end, 100)
end

function M.on_progress(ev)
	local value = ev.data.params.value
	if type(value) == "table" and value.kind == "end" then
		M.refresh(ev.data.client_id)
	end
end

function M.redraw(ev)
	if vim.api.nvim_buf_is_valid(ev.buf) and vim.bo[ev.buf].filetype == "lua" then
		vim.api.nvim__redraw({ buf = ev.buf, valid = false, statuscolumn = true })
	end
end

return M
