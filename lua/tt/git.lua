local M = {}
local api = vim.api
local fn = vim.fn
local shell_to_buf = require("tt.nvim_utils").vim_util.shell_to_buf
local namespace = api.nvim_create_namespace("git_lens")

function M.diff()
	local fileName = fn.expand("%")
	local ext = fn.expand("%:e")
	local buf = shell_to_buf({ "git", "show", "HEAD:" .. fileName })
	vim.cmd.wincmd("v")
	vim.cmd.wincmd("h")
	api.nvim_win_set_buf(0, buf)
	vim.bo.filetype = ext
	vim.cmd.diffthis()
	vim.cmd.wincmd("l")
	vim.cmd.diffthis()
end

function M.blame_file()
	local fileName = fn.expand("%")
	local buf = shell_to_buf({ "git", "blame", fileName })
	vim.cmd("40wincmd v")
	vim.cmd.wincmd("r")
	api.nvim_win_set_buf(0, buf)
	vim.bo.filetype = "fugitiveblame"
	vim.cmd.wincmd("h")
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

local function listChangedFiles()
	local result = vim.system({ "git", "diff", "--name-only", "--no-color" }):wait()
	if result.code == 0 and result.stdout then
		return vim.split(vim.trim(result.stdout), "\n")
	else
		return {}
	end
end

local function jumpToDiff()
	vim.cmd("silent only")
	vim.cmd("vsplit <cfile>")
	M.diff()
	vim.cmd.wincmd("h")
	vim.cmd.wincmd("h")
end

function M.changedFiles()
	vim.cmd.tabnew()
	local files = listChangedFiles()
	local buf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(buf, 0, -1, true, files)
	api.nvim_win_set_buf(0, buf)
	vim.keymap.set("n", "<CR>", jumpToDiff, { buffer = buf })
	vim.keymap.set("n", "Q", ":tabclose<CR>", { buffer = buf })
end

return M
