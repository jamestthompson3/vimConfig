local M = {}
local tokens = {}

function M.sync(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	local busy = false
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
		if tokens[client.id] and next(tokens[client.id]) then
			busy = true
		end
	end
	vim.bo[buf].busy = busy and 1 or 0
end

function M.update(ev)
	local id, params = ev.data.client_id, ev.data.params
	local client = vim.lsp.get_client_by_id(id)
	if not client then
		tokens[id] = nil
		return
	end
	local value = params.value
	if type(value) ~= "table" or params.token == nil then
		return
	end
	if value.kind == "begin" or value.kind == "report" then
		tokens[id] = tokens[id] or {}
		tokens[id][params.token] = true
	elseif value.kind == "end" and tokens[id] then
		tokens[id][params.token] = nil
		if not next(tokens[id]) then
			tokens[id] = nil
		end
	end
	for buf in pairs(client.attached_buffers) do
		M.sync(buf)
	end
end

function M.detach(id, buf)
	vim.schedule(function()
		local client = vim.lsp.get_client_by_id(id)
		if not client or not next(client.attached_buffers) then
			tokens[id] = nil
		end
		M.sync(buf)
	end)
end

return M
