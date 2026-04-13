local M = {}

function M.init()
	local lines = vim.fn.line("$")
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
