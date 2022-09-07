local M = {}

local themes = { "tropics-light", "substrata", "tropics" }
local lushwright = require("shipwright.transform.lush")

for _, theme in pairs(themes) do
	local colorscheme = require("lush_theme." .. theme)
	run(colorscheme, lushwright.to_vimscript, { overwrite, "colors/" .. theme .. ".vim" })
end

return M
