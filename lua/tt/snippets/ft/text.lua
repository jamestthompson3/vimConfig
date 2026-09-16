local M = {}

local function stamp()
	return vim.fn.strftime("%Y%m%d%H%M")
end

M.init = function()
	vim.snippet.add("twh", function()
		local ts = stamp()
		local name = vim.fn.expand("%:t:r")
		return "content-type: wikitext\ncreated: "
			.. ts
			.. "\ntitle: "
			.. name
			.. "\nmodified: "
			.. ts
			.. "\nid: "
			.. name
			.. "\ntags: [$2]\n\n"
	end)
	vim.snippet.add("dtt", stamp)
end
return M
