local M = {}

function M.is_large(buf)
	buf = buf or 0
	if not vim.api.nvim_buf_is_valid(buf) then
		return true
	end
	local lines = vim.api.nvim_buf_line_count(buf)
	local bytes = vim.api.nvim_buf_get_offset(buf, lines)
	return lines > (vim.g.large_buffer_lines or 30000) or bytes > (vim.g.large_buffer_bytes or 1024 * 1024)
end

return M
