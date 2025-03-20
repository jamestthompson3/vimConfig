function vim.snippet.add(trigger, body, opts)
	vim.keymap.set("ia", trigger, function()
		vim.snippet.expand(body)
	end, { buffer = true })
end

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if vim.snippet.active() then
		vim.snippet.jump(1)
	end
end)

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if vim.snippet.active() then
		vim.snippet.jump(-1)
	end
end)
