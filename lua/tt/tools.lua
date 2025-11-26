local git = require("tt.git")
local api = vim.api
local fn = vim.fn

local sessionPath = vim.fs.joinpath(vim.uv.os_homedir(), "sessions")

local M = {}

function M.openQuickfix()
	local qflen = fn.len(fn.getqflist())
	local qfheight = math.min(10, qflen)
	vim.cmd(string.format("cclose|%dcwindow", qfheight))
end

function M.splashscreen()
	local curr_buf = api.nvim_get_current_buf()
	local args = vim.fn.argc()
	local offset = api.nvim_buf_get_offset(curr_buf, 1)
	if args == 0 and offset <= 1 then
		api.nvim_create_buf(false, true)
		vim.cmd([[ silent! r ~/vim/skeletons/start.screen ]])
		vim.bo[0].bufhidden = "wipe"
		vim.bo[0].buflisted = false
		vim.bo[0].matchpairs = ""
		vim.opt_local.relativenumber = true
		vim.opt_local.cursorline = false
		vim.wo[0].cursorcolumn = false
		M.simpleMRU()
		vim.cmd([[:34]])
		vim.keymap.set("n", "<CR>", "gf", { buffer = true, noremap = true })
		vim.bo[0].modified = false
		vim.bo[0].modifiable = false
	else
	end
end

function M.openTerminalDrawer()
	vim.cmd.copen()
	vim.cmd.term()
	api.nvim_input("i")
end

function M.restoreFile()
	local cmd = "git restore " .. fn.expand("%")
	vim.cmd("!" .. cmd)
end

function M.renameFile()
	local oldName = api.nvim_get_current_line()
	local input_cmd = string.format("input('Rename: ', '%s', 'file')", oldName)
	local newName = api.nvim_eval(input_cmd)
	os.rename(oldName, newName)
	api.nvim_input("R")
end

function M.deleteFile()
	local fileName = api.nvim_get_current_line()
	os.remove(fileName)
	api.nvim_input("R")
end

function M.winMove(key)
	local currentWindow = fn.winnr()
	vim.cmd.wincmd(key)
	if fn.winnr() == currentWindow then
		if key == "j" or key == "k" then
			vim.cmd.wincmd("s")
		else
			vim.cmd.wincmd("v")
		end
		vim.cmd.wincmd(key)
	end
end

-- Session Management
function M.createSessionName(custom_name)
	local git_root = vim.fs.root(0, ".git")
	local project_name
	if git_root then
		project_name = vim.fn.fnamemodify(git_root, ":t")
	else
		project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	end
	local branch_name = git.branch()
	if branch_name == "" or branch_name == "master" or branch_name == "main" then
		branch_name = "default"
	else
		branch_name = branch_name:gsub("/", "-")
	end

	if custom_name and custom_name ~= "" then
		local cleared = custom_name:gsub("/", "-"):gsub("%s+", "_")
		return string.format("%s_%s_%s", project_name, branch_name, cleared)
	else
		return string.format("%s_%s", project_name, branch_name)
	end
end

function M.saveSession(session_name)
	-- When called as autocmd callback, session_name is an event table
	if type(session_name) == "table" then
		session_name = nil
	end
	local sessionName = M.createSessionName(session_name)
	local cmd = string.format("mks! %s/%s.vim", sessionPath, sessionName)
	vim.cmd(cmd)
end

function M.sourceSession(session_name)
	local sessionName = M.createSessionName(session_name)
	local sessionFile = string.format("%s/%s.vim", sessionPath, sessionName)
	if vim.fn.filereadable(sessionFile) == 1 then
		vim.cmd("so " .. sessionFile)
	else
		-- Session doesn't exist, create it
		M.saveSession(session_name)
		vim.notify("Created new session: " .. sessionName, vim.log.levels.INFO)
	end
end

function M.simpleMRU()
	local files = vim.v.oldfiles
	local cwd = vim.fn.getcwd(0)
	local filteredFiles = vim.tbl_filter(function(file)
		return vim.startswith(file, cwd) and vim.fn.filereadable(file) == 1 and not string.find(file, "COMMIT_MESSAGE")
	end, files)
	for _, file in ipairs(filteredFiles) do
		local fname = vim.fn.fnamemodify(file, ":.")
		vim.fn.append(vim.fn.line("$") - 1, vim.trim(fname))
	end
	vim.cmd([[:1]])
end

function M.profile()
	if vim.g.profiler_running ~= nil then
		vim.cmd("profile pause")
		vim.g.profiler_running = nil
		vim.cmd("noautocmd qall!")
	else
		vim.g.profiler_running = 1
		vim.cmd("profile start profile.log")
		vim.cmd("profile func *")
		vim.cmd("profile file *")
	end
end

return M
