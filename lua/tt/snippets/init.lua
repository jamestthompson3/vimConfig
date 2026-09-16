-- `body` is either a snippet string or a function returning one. The function
-- form defers evaluation to expansion time, so snippets built from the date or
-- filename stay live instead of freezing at buffer load.
function vim.snippet.add(trigger, body)
	vim.keymap.set("ia", trigger, function()
		vim.snippet.expand(type(body) == "function" and body() or body)
	end, { buffer = true })
end
