local M = {}

function M.submit(buf)
	local failed = {}
	for _, original in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		local line = vim.trim(original)
		if line ~= "" then
			local prefix, rest = line:sub(1, 1), vim.trim(line:sub(2))
			if prefix == "!" and rest ~= "" then
				line = rest .. " @nag"
			end
			local ok, result = pcall(function()
				return vim.system({ "todo.sh", "add" }, { stdin = line }):wait(5000)
			end)
			if not ok or result.code ~= 0 then
				failed[#failed + 1] = original
				vim.notify(
					"todo: " .. (ok and (result.stderr or "command failed") or tostring(result)),
					vim.log.levels.ERROR
				)
			end
		end
	end
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	if #failed > 0 then
		-- Remove successful submissions so a retry cannot add duplicate tasks.
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, failed)
		vim.bo[buf].modified = true
		vim.notify("Unsubmitted tasks remain in the todo buffer", vim.log.levels.WARN)
	else
		vim.api.nvim_buf_delete(buf, { force = true })
	end
end

return M
