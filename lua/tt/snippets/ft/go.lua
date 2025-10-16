local M = {}
M.init = function()
	vim.snippet.add("ien", "if err != nil {\n\t$1\n}")
end
return M
