local api = vim.api
local M = {}

if not vim.w.callout_match then
	vim.w.callout_match = vim.fn.matchadd("Callout", [[\v\@\w+\.?\w+]])
end

vim.keymap.set("ia", "dateheader", function()
	return os.date("%Y %b %d")
end, { buf = 0, expr = true })

function M.composer()
	vim.wo[0].wrap = true
	vim.wo[0].linebreak = true
	vim.opt_local.spell = true
end

vim.wo[0][0].foldlevel = 1
vim.wo[0][0].conceallevel = 0

function M.asyncDocs()
	local shortname = vim.fn.expand("%:t:r")
	local fullname = api.nvim_buf_get_name(0)

	vim.system({
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
		vim.fs.normalize(vim.fs.joinpath(vim.env.NOTES_DIR or "~/notes", "notes.css")),
	}, { text = true }, function(result)
		vim.schedule(function()
			if result.code == 0 then
				vim.notify("pandoc: wrote " .. shortname .. ".html")
			else
				vim.notify("pandoc: " .. (result.stderr or ""), vim.log.levels.ERROR)
			end
		end)
	end)
end

vim.api.nvim_buf_create_user_command(0, "Compose", function()
	M.composer()
end, {})

vim.keymap.set("n", "j", "gj", { buf = 0 })
vim.keymap.set("n", "k", "gk", { buf = 0 })
vim.keymap.set("n", "<leader>r", M.asyncDocs, { buf = 0 })

return M
