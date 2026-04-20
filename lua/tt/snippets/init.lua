function vim.snippet.add(trigger, body, opts)
	vim.keymap.set("ia", trigger, function()
		vim.snippet.expand(body)
	end, { buffer = true })
end
