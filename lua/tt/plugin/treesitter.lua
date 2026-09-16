local M = {}

function M.init()
	local lines = vim.api.nvim_buf_line_count(0)
	if lines > 30000 then
		return
	end

	require("treesitter-context").setup({
		enable = true,
		max_lines = -1,
		multiwindow = true,
		trim_scope = "outer",
	})
end

return M
