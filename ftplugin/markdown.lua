local iabbrev = require("tt.nvim_utils").vim_util.iabbrev
local api = vim.api
local M = {}

vim.fn.matchadd("Callout", "@w+.?w+")

iabbrev("<expr> dateheader", vim.fn.strftime("%Y %b %d"), true)

function M.composer()
	vim.wo[0].wrap = true
	vim.wo[0].linebreak = true
	vim.wo[0].spell = true
end

function M.createFile() end

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

function M.previewLinkedPage()
	local width = api.nvim_get_option_value("columns", {})
	local height = api.nvim_get_option_value("lines", {})
	-- if the editor is big enough
	if width > 150 or height > 35 then
		-- fzf's window height is 3/4 of the max height, but not more than 30
		local win_height = math.min(math.ceil(height * 3 / 4), 30)
		local win_width

		-- if the width is small
		if width < 150 then
			-- just subtract 8 from the editor's width
			win_width = math.ceil(width - 8)
		else
			-- use 90% of the editor's width
			win_width = math.ceil(width * 0.9)
		end
		local buf = api.nvim_create_buf(false, true)
		local filename = vim.fn.expand("<cword>")
		local opts = {
			relative = "editor",
			width = win_width,
			height = win_height,
			row = math.ceil((height - win_height) / 2),
			col = math.ceil((width - win_width) / 2),
			style = "minimal",
		}
		api.nvim_open_win(buf, true, opts)
		vim.cmd(string.format("read %s.md", filename))
		api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", {})
	end
end

vim.api.nvim_create_user_command("Compose", function() require'tt.ft.markdown'.composer() end, {})

vim.keymap.set("n", "j", "gj", { buffer = true })
vim.keymap.set("n", "k", "gk", { buffer = true })
vim.keymap.set("n", "gh", M.previewLinkedPage, { buffer = true })
vim.keymap.set("n", "<leader>r", M.asyncDocs, { buffer = true })

return M
