local api = vim.api
local M = {}

vim.fn.matchadd("Callout", [[\v\@\w+\.?\w+]])

vim.cmd.iabbrev({ args = { "<buffer>", "<expr> dateheader", vim.fn.strftime("%Y %b %d") } })

function M.composer()
	vim.wo[0].wrap = true
	vim.wo[0].linebreak = true
	vim.opt_local.spell = true
end

vim.wo.foldlevel = 1
vim.wo.conceallevel = 0

function M.asyncDocs()
	local shortname = vim.fn.expand("%:t:r")
	local fullname = api.nvim_buf_get_name(0)

	vim.fn.jobstart({
		"pandoc",
		fullname,
		"--from",
		"gfm",
		"--to=html5",
		"-o",
		string.format("%s.html", shortname),
		"-s",
		"--highlight-style",
		"tango",
		"-c",
		"$NOTES_DIR/notes.css",
	}, {
		on_exit = function(_, code)
			if code == 0 then
				print("FILE CONVERSION COMPLETE")
			end
		end,
	})
end

vim.api.nvim_create_user_command("Compose", function()
	M.composer()
end, {})

vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })
vim.keymap.set("n", "<leader>r", M.asyncDocs, { buffer = true })

return M
