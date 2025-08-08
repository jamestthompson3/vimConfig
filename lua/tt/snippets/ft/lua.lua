local M = {}
M.init = function()
	vim.snippet.add("l", "log($1)")
	vim.snippet.add("req", 'local $1 = require("$1")')
end
return M
