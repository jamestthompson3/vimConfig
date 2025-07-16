local globals = require("tt.nvim_utils").GLOBALS
local buf_map = require("tt.nvim_utils").keys.buf_nnoremap
local git = require("tt.git")
local api = vim.api
local fn = vim.fn

local sessionPath = vim.fs.joinpath(globals.home, "sessions")

local M = {}

function M.openQuickfix()
	local qflen = fn.len(fn.getqflist())
	local qfheight = math.min(10, qflen)
	api.nvim_command(string.format("cclose|%dcwindow", qfheight))
end

function M.splashscreen()
	local curr_buf = api.nvim_get_current_buf()
	local args = vim.fn.argc()
	local offset = api.nvim_buf_get_offset(curr_buf, 1)
	if args == 0 and offset <= 1 then
		api.nvim_create_buf(false, true)
		api.nvim_command([[ silent! r ~/vim/skeletons/start.screen ]])
		vim.bo[0].bufhidden = "wipe"
		vim.bo[0].buflisted = false
		vim.bo[0].matchpairs = ""
		api.nvim_command([[setl relativenumber]])
		api.nvim_command([[setl nocursorline]])
		vim.wo[0].cursorcolumn = false
		M.simpleMRU()
		api.nvim_command([[:34]])
		buf_map({ "<CR>", "gf", { noremap = true } })
		vim.bo[0].modified = false
		vim.bo[0].modifiable = false
	else
	end
end

function M.openTerminalDrawer()
	api.nvim_command([[ copen ]])
	api.nvim_command([[ term ]])
	api.nvim_input("i")
end

function M.restoreFile()
	local cmd = "git restore " .. fn.expand("%")
	api.nvim_command("!" .. cmd)
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
	api.nvim_command("wincmd " .. key)
	if fn.winnr() == currentWindow then
		if key == "j" or key == "k" then
			api.nvim_command("wincmd s")
		else
			api.nvim_command("wincmd v")
		end
		api.nvim_command("wincmd " .. key)
	end
end

function M.removeWhitespace()
	if 1 == vim.g.remove_whitespace then
		api.nvim_exec("normal mz", false)
		api.nvim_command("%s/\\s\\+$//ge")
		api.nvim_exec("normal `z", false)
	end
end

function M.grepBufs(term)
	local cmd = string.format("silent bufdo vimgrepadd %s %", term)
	api.nvim_command(cmd)
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
	local cmd = string.format("mks! %s%s.vim", sessionPath, sessionName)
	api.nvim_command(cmd)
end

function M.sourceSession()
	local sessionName = M.createSessionName()
	local cmd = string.format("so %s%s.vim", sessionPath, sessionName)
	api.nvim_command(cmd)
end

function M.simpleMRU()
	local files = vim.v.oldfiles
	local cwd = globals.cwd()
	local filteredFiles = vim.tbl_filter(function(file)
		return vim.startswith(file, cwd) and vim.fn.filereadable(file) == 1 and not string.find(file, "COMMIT_MESSAGE")
	end, files)
	for _, file in ipairs(filteredFiles) do
		local fname = vim.fn.fnamemodify(file, ":.")
		api.nvim_command(string.format('call append(line("$") -1, "%s")', vim.trim(fname)))
	end
	api.nvim_command([[:1]])
end

function M.listTags()
	local cword = fn.expand("<cword>")
	api.nvim_command("ltag " .. cword)
	api.nvim_command([[ lwindow ]])
end

function M.profile()
	if vim.g.profiler_running ~= nil then
		api.nvim_command("profile pause")
		vim.g.profiler_running = nil
		api.nvim_command("noautocmd qall!")
	else
		vim.g.profiler_running = 1
		api.nvim_command("profile start profile.log")
		api.nvim_command("profile func *")
		api.nvim_command("profile file *")
	end
end

M.kind_symbols = {
	Text = "␂ Text",
	Method = "🜜  Method",
	Function = "⎔ Func",
	Constructor = "⌂ Constructor",
	Variable = "⊷ Var",
	Class = "⌻ Class",
	Interface = "∮ Interface",
	Module = "⌘ Module",
	Property = " ∴ Property",
	Unit = "⍚ Unit",
	Value = "⋯ Value",
	Enum = "⎆ Enum",
	Keyword = "⚿  Keyword",
	Snippet = "⮑  Snippet",
	Color = "🜚 Color",
	File = "𐂧 File",
	Folder = "𐂽 Folder",
	EnumMember = "⍆ EnumMember",
	Constant = "🜛 Constant",
	Struct = "⨊ Struct",
}

return M
