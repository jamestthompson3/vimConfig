local snippets = require("tt.snippets")
local M = {}
M.init = function()
	snippets.add("fn", "function $1 ($2): $3 {\n\t$4\n}")
	snippets.add("cn", "const $1 = ($2): $3 => {\n\t$4\n}")
end
return M
