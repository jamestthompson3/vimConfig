local M = {}
M.init = function()
	vim.snippet.add("twh", "content-type: wikitext\ncreated: $1\ntitle: $2\nmodified: $3\nid: $4\ntags: []\n\n")
	vim.snippet.add("dtt", vim.fn.strftime("%Y%M%d%H%M"))
end
return M

-- Note: Original snippet used the current timestamp and filename, which can be manually added
