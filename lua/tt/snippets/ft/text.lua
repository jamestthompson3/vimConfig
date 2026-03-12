local M = {}
M.init = function()
	vim.snippet.add(
		"twh",
		"content-type: wikitext\ncreated: "
			.. vim.fn.strftime("%Y%M%d%H%M")
			.. "\ntitle: "
			.. vim.fn.expand("%:t:r")
			.. "\nmodified: "
			.. vim.fn.strftime("%Y%M%d%H%M")
			.. "\nid: "
			.. vim.fn.expand("%:t:r")
			.. "\ntags: [$2]\n\n"
	)
	vim.snippet.add("dtt", vim.fn.strftime("%Y%M%d%H%M"))
end
return M

-- Note: Original snippet used the current timestamp and filename, which can be manually added
