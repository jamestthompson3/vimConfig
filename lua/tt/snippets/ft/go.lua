local snippets = require("tt.snippets")
local M = {}
M.init = function()
	snippets.add("ien", "if err != nil {\n\t$1\n}")
end
return M
