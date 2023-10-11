local M = {}
local buf_nnoremap = require("tt.nvim_utils").keys.buf_nnoremap
local stb = require("tt.nvim_utils").vim_util.shell_to_buf
local api = vim.api
local fn = vim.fn
local namespace = api.nvim_create_namespace("git_lens")

local function cmd(cmd)
	if is_windows then
		return "git " .. cmd .. " 2> NUL | tr -d '\n'"
	else
		return "git " .. cmd .. " 2> /dev/null | tr -d '\n'"
	end
end

function M.diff()
	local fileName = fn.expand("%")
	local sub_cmd = fn.system("git rev-parse --show-toplevel")
	local project_root_path = sub_cmd:gsub("\n", "/")
	local ext = fn.expand("%:e")
	local buf = stb({ "git", "show", "HEAD:" .. project_root_path .. fileName })
	api.nvim_command("wincmd v")
	api.nvim_win_set_buf(0, buf)
	api.nvim_command("set ft=" .. ext)
	api.nvim_command("wincmd h")
	api.nvim_command("diffthis")
	api.nvim_command("wincmd l")
	api.nvim_command("diffthis")
end

function M.blame_file()
	local fileName = fn.expand("%")
	local buf = stb({ "git", "blame", fileName })
	api.nvim_command("40wincmd v")
	api.nvim_command("wincmd r")
	api.nvim_win_set_buf(0, buf)
	api.nvim_command("set ft=fugitiveblame")
	api.nvim_command("wincmd h")
end

function M.blame()
	local ft = fn.expand("%:h:t")
	if ft == "" then
		return
	end
	if ft == "bin" then
		return
	end
	api.nvim_buf_clear_namespace(0, 99, 0, -1)
	local currFile = fn.expand("%")
	local line = api.nvim_win_get_cursor(0)
	local blame = fn.system(string.format("git blame -c -L %d,%d %s", line[1], line[1], currFile))
	local hash = vim.split(blame, "%s")[1]
	local cmd = string.format("git show %s ", hash) .. "--format='%an, %ar • %s'"
	if hash == "00000000" then
		text = "Not Committed Yet"
	else
		text = fn.system(cmd)
		text = vim.split(text, "\n")[1]
		if text:find("fatal") then
			text = "Not Committed Yet"
		end
	end
	api.nvim_buf_set_extmark(0, namespace, line[1] - 1, line[2], {
		virt_text = { { string.format("%s", text), "GitLens" } },
	})
end

function M.clear_blame()
	api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end

function M.branch()
	if is_windows then
		return os.capture("git rev-parse --abbrev-ref HEAD 2> NUL"):gsub("\\n", "")
	else
		return os.capture("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
	end
end

-- returns short status of changes
function M.stat()
	return os.capture(cmd("diff --shortstat"))
end

local function listChangedFiles()
	return fn.systemlist("git diff --name-only --no-color")
end

local function jumpToDiff()
	api.nvim_command("silent only")
	api.nvim_command("vsplit <cfile>")
	M.diff()
	api.nvim_command("wincmd h")
	api.nvim_command("wincmd h")
end

function M.QfFiles()
	local files = listChangedFiles()
	local qfFiles = {}
	for _, file in ipairs(files) do
		table.insert(qfFiles, { filename = file, lnum = 1 })
	end
	fn.setqflist(qfFiles, "r")
end

function M.changedFiles()
	api.nvim_command("tabnew")
	local buf = stb({ "git", "diff", "--name-only", "--no-color" })
	api.nvim_win_set_buf(0, buf)
	buf_nnoremap({ "<CR>", jumpToDiff, { buffer = buf } })
	buf_nnoremap({ "Q", ":tabclose<CR>", { buffer = buf } })
end

return M
