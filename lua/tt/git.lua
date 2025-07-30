local M = {}
local api = vim.api
local fn = vim.fn
local buf_nnoremap = require("tt.nvim_utils").keys.buf_nnoremap
local shell_to_buf = require("tt.nvim_utils").vim_util.shell_to_buf
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
	local ext = fn.expand("%:e")
	local buf = shell_to_buf({ "git", "show", "HEAD:" .. fileName })
	api.nvim_command("wincmd v")
	api.nvim_command("wincmd h")
	api.nvim_win_set_buf(0, buf)
	api.nvim_command("set ft=" .. ext)
	api.nvim_command("diffthis")
	api.nvim_command("wincmd l")
	api.nvim_command("diffthis")
end

function M.blame_file()
	local fileName = fn.expand("%")
	local buf = shell_to_buf({ "git", "blame", fileName })
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
	local log_result = vim.system({
		"git",
		"log",
		"-1",
		"--format=%an, %ar • %s",
		"-L",
		string.format("%d,%d:%s", line[1], line[1], currFile),
	}, { text = true }):wait()
	if log_result.code ~= 0 or not log_result.stdout then
		return "Not Committed Yet"
	end

	text = vim.split(log_result.stdout, "\n")

	api.nvim_buf_set_extmark(0, namespace, line[1] - 1, line[2], {
		virt_text = { { string.format("%s", text[1]), "GitLens" } },
	})
end

function M.clear_blame()
	api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end

function M.branch()
	local command = {}
	if is_windows then
		command = { "git", "rev-parse", "--abbrev-ref", "HEAD" }
	else
		command = { "git", "rev-parse", "--abbrev-ref", "HEAD" }
	end
	local result = vim.system(command):wait()
	if result.code == 0 and result.stdout then
		if is_windows then
			return result.stdout:gsub("\\n", "")
		else
			return result.stdout:gsub("\n", "")
		end
	else
		return ""
	end
end

-- returns short status of changes
function M.stat()
	local command = cmd("diff --shortstat")
	local result = vim.system({ command }):wait()
	return result.stdout or ""
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
	local files = listChangedFiles()
	local buf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(buf, 0, -1, true, files)
	api.nvim_win_set_buf(0, buf)
	buf_nnoremap({ "<CR>", jumpToDiff, { buffer = buf } })
	buf_nnoremap({ "Q", ":tabclose<CR>", { buffer = buf } })
end

return M
