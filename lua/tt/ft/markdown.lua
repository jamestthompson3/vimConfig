require("tt.nvim_utils")
require("tt.navigation")
local api = vim.api
local M = {}
local setWriterline = false

function M.composer()
	vim.wo[0].wrap = true
	vim.wo[0].linebreak = true
	vim.wo[0].spell = true
	vim.bo[0].textwidth = 0
	if setWriterline then
		return
	else
		api.nvim_command([[ set statusline+=\ %{wordcount().words}\ words ]])
		setWriterline = true
	end
end

function M.createFile()
end

-- Globals
vim.g.markdown_fenced_languages = { "html", "typescript", "javascript", "js=javascript", "bash=sh", "rust" }

vim.wo.foldlevel = 1

local mappings = {
	["nj"] = { "gj", noremap = true, buffer = true },
	["nk"] = { "gk", noremap = true, buffer = true },
	["ngh"] = map_cmd("lua require'tt.ft.markdown'.previewLinkedPage()", true),
	["n<leader>r"] = map_cmd("lua require'tt.ft.markdown'.asyncDocs()", true),
	["n<leader><CR>"] = map_cmd("call waikiki#FollowLink()", true),
}

function M.asyncDocs()
	local shortname = vim.fn.expand("%:t:r")
	local fullname = api.nvim_buf_get_name(0)
	spawn("pandoc", {
		args = {
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
		},
	}, function()
		print("FILE CONVERSION COMPLETE")
	end)
end

function M.previewLinkedPage()
	local width = api.nvim_get_option("columns")
	local height = api.nvim_get_option("lines")
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
		api.nvim_command(string.format("read %s.md", filename))
		api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", {})
	end
end

nvim.command([[command! Compose lua require'tt.ft.markdown'.composer()]])

nvim_apply_mappings(mappings)

return M
