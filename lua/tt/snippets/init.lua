local M = {}

-- Evaluate date and filename values when the abbreviation expands.
function M.add(trigger, body)
	vim.keymap.set("ia", trigger, function()
		vim.snippet.expand(type(body) == "function" and body() or body)
	end, { buf = 0 })
end

return M
