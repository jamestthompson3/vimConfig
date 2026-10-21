local snippets = require("tt.snippets")
local M = {}
M.init = function()
	snippets.add("l", "vim.print($1)")
	snippets.add("req", 'local $1 = require("$1")')
end
return M
