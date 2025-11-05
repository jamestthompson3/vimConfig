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
function M.createSessionName()
	local sessionName = git.branch()
	if not sessionName == "" or sessionName == "master" then
		return "default" --currDir
	else
		return sessionName:gsub("/", "-")
	end
end

function M.saveSession()
	local sessionName = M.createSessionName()
	local cmd = string.format("mks! %s/%s.vim", sessionPath, sessionName)
	vim.cmd(cmd)
end

function M.sourceSession()
	local sessionName = M.createSessionName()
	local cmd = string.format("so %s/%s.vim", sessionPath, sessionName)
	vim.cmd(cmd)
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
