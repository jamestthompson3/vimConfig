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
		vim.keymap.set("n", "<CR>", ":e<cWORD><CR>", { buffer = true, noremap = true, silent = true })
		vim.bo[0].modified = false
		vim.bo[0].modifiable = false
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

function M.files_to_qf(filename)
	local files = vim.fn.systemlist({ "fd", "--type", "f", "--hidden", "-E", ".git", "-g", filename })
	if #files == 0 then
		vim.notify("No files found: " .. filename, vim.log.levels.WARN)
		return
	end
	local items = vim.tbl_map(function(file)
		return { filename = file, lnum = 1 }
	end, files)
	vim.fn.setqflist({}, " ", { title = filename, items = items })
	M.openQuickfix()
end

function M.switchSourceHeader()
	local ext = fn.expand("%:e")
	local base = fn.expand("%:t:r")
	local dir = fn.expand("%:p:h")
	local targets
	if ext == "h" or ext == "hpp" then
		targets = { "c", "cpp", "m", "mm" }
	else
		targets = { "h", "hpp" }
	end
	-- Try same directory first
	for _, t in ipairs(targets) do
		local candidate = dir .. "/" .. base .. "." .. t
		if vim.uv.fs_stat(candidate) then
			vim.cmd.edit(candidate)
			return
		end
	end
	-- Fall back to searching the project
	local root = vim.fs.root(0, { ".git", "Makefile", "CMakeLists.txt" }) or fn.getcwd()
	for _, t in ipairs(targets) do
		local found = vim.fs.find(base .. "." .. t, { path = root, type = "file" })
		if #found > 0 then
			vim.cmd.edit(found[1])
			return
		end
	end
	vim.notify("No match for " .. base .. ".{" .. table.concat(targets, ",") .. "}", vim.log.levels.WARN)
end

function M.redir(cmd)
	for win = 1, fn.winnr("$") do
		if fn.getwinvar(win, "scratch") == 1 then
			vim.cmd(win .. "windo close")
		end
	end
	local output
	if cmd:match("^!") then
		output = fn.system(cmd:sub(2))
	else
		output = vim.api.nvim_exec2(cmd, { output = true }).output
	end
	vim.cmd("vnew")
	vim.w.scratch = 1
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.buflisted = false
	vim.bo.swapfile = false
	vim.keymap.set("n", "q", "<C-w>c", { buffer = true })
	api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))
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
