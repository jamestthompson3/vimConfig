local api = vim.api

if vim.g.loaded_improvedsearch then
	return
end

local line_limit = 1000000
