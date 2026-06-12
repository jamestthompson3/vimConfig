local M = {}
local api = vim.api
local fn = vim.fn
local namespace = api.nvim_create_namespace("git_lens")

local function teardown(work_buf, head_buf)
	for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do
		if api.nvim_win_get_buf(w) == work_buf then
			api.nvim_set_current_win(w)
			break
		end
	end
	vim.cmd("diffoff!")
	vim.cmd("only")
	if head_buf and api.nvim_buf_is_valid(head_buf) then
		pcall(api.nvim_buf_delete, head_buf, { force = true })
	end
end

function M.diff(file)
	vim.cmd.packadd("nvim.difftool")
	local relpath = file or fn.expand("%")
	local fullpath = fn.fnamemodify(relpath, ":p")
	local ext = fn.fnamemodify(relpath, ":e")
	local tmpfile = fn.tempname() .. "." .. ext
	local result = vim.system({ "git", "show", "HEAD:" .. relpath }, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify("Not in git or no HEAD version", vim.log.levels.WARN)
		return
	end
	local f = io.open(tmpfile, "w")
	f:write(result.stdout)
	f:close()

	require("difftool").open(tmpfile, fullpath)

	local work_buf = fn.bufnr(fullpath)
	local head_buf = fn.bufnr(tmpfile)
	if head_buf ~= -1 then
		-- make the HEAD snapshot obviously disposable + unsaveable
		vim.bo[head_buf].buftype = "nofile"
		vim.bo[head_buf].bufhidden = "wipe"
		vim.bo[head_buf].modifiable = false
		vim.bo[head_buf].readonly = true
		pcall(api.nvim_buf_set_name, head_buf, "HEAD:" .. relpath)
	end
	for _, b in ipairs({ work_buf, head_buf }) do
		if b ~= -1 then
			vim.keymap.set("n", "q", function()
				teardown(work_buf, head_buf)
			end, { buffer = b, desc = "Close diff, return to working file" })
		end
	end
end

function M.blame_file()
	local fileName = fn.expand("%")
	local buf = api.nvim_create_buf(false, true)
	local result = vim.system({ "git", "blame", fileName }):wait()
	local lines = vim.split(result.stdout or "", "\n")
	api.nvim_buf_set_lines(buf, 0, -1, true, lines)
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
	local result = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }):wait()
	if result.code == 0 and result.stdout then
		return vim.trim(result.stdout)
	end
	return ""
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
	M.diff(fn.expand("<cfile>"))
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
