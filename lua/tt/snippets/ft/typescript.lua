local M = {}
M.init = function()
	vim.snippet.add("fn", "function $1 ($2): $3 {\n\t$4\n}")
	vim.snippet.add("cn", "const $1 = ($2): $3 => {\n\t$4\n}")
end
return M
