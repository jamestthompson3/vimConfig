local globals = require("tt.nvim_utils").GLOBALS
local git = require("tt.git")
local api = vim.api
local fn = vim.fn
require("tt.navigation")

local sessionPath = globals.home .. globals.file_separator .. "sessions" .. globals.file_separator

local M = {}

function M.openQuickfix()
	local qflen = fn.len(fn.getqflist())
	local qfheight = math.min(10, qflen)
	api.nvim_command(string.format("cclose|%dcwindow", qfheight))
end

function M.compile_theme(theme)
	local lines = require("lush").compile(require("lush_theme." .. theme))
	vim.fn.writefile(lines, "colors/" .. theme .. ".vim")
end

function M.cheatsheet()
	NavigationFloatingWin()
	api.nvim_command([[ term ]])
	api.nvim_input("icht<CR>")
	-- api.nvim_feedkeys("cht", 'i', false)
end

function M.splashscreen()
	local curr_buf = api.nvim_get_current_buf()
	local args = vim.fn.argc()
	local offset = api.nvim_buf_get_offset(curr_buf, 1)
	local currDir = globals.cwd()
	if offset == -1 and args == 0 then
		api.nvim_create_buf(false, true)
		api.nvim_command([[ silent! r ~/vim/skeletons/start.screen ]])
		-- nvim.command(string.format("chdir %s", currDir))
		vim.bo[0].bufhidden = "wipe"
		vim.bo[0].buflisted = false
		vim.bo[0].matchpairs = ""
		api.nvim_command([[setl relativenumber]])
		api.nvim_command([[setl nocursorline]])
		vim.wo[0].cursorcolumn = false
		require("tt.tools").simpleMRU()
		api.nvim_command([[:34]])
		api.nvim_buf_set_keymap(0, "n", "<CR>", "gf", { noremap = true })
		vim.bo[0].modified = false
		vim.bo[0].modifiable = false
	else
	end
end

function M.openTerminalDrawer(floating)
	if floating == 1 then
		NavigationFloatingWin()
	else
		api.nvim_command([[ copen ]])
	end
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
	local currDir = globals.cwd()
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
	for _, file in ipairs(files) do
		if not vim.startswith(file, "term://") and string.match(getPath(file), cwd) then
			local splitvals = vim.split(file, "/")
			local fname = splitvals[#splitvals]
			api.nvim_command(string.format('call append(line("$") -1, "%s")', vim.trim(fname)))
		end
	end
	api.nvim_command([[:1]])
end

function M.listTags()
	local cword = fn.expand("<cword>")
	api.nvim_command("ltag " .. cword)
	api.nvim_command([[ lwindow ]])
end

function M.statuslineHighlight()
	local fileName = vim.fn.fnamemodify(api.nvim_buf_get_name(0), ":p:t")
	local extension = vim.fn.fnamemodify(api.nvim_buf_get_name(0), ":e")
	local icon, icon_highlight = icons.get_icon(fileName, extension, { default = true })
	return icon_highlight
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

M.kind_symbols = function()
	local icons_present = pcall(require, "nvim-nonicons")
	if icons_present then
		local icons = require("nvim-nonicons")
		return {
			Text = " Text",
			Method = "ƒ Method",
			Function = icons.get("pulse") .. " Func",
			Constructor = " Constructor",
			Variable = icons.get("variable") .. " Var",
			Class = icons.get("class") .. " Class",
			Interface = "ﰮ" .. " Interface",
			Module = icons.get("package") .. " Module",
			Property = " Property",
			Unit = " Unit",
			Value = icons.get("ellipsis") .. " Value",
			Enum = icons.get("workflow") .. " Enum",
			Keyword = " Keyword",
			Snippet = "﬌ Snippet",
			Color = " Color",
			File = icons.get("file") .. " File",
			Folder = icons.get("file-directory-outline") .. " Folder",
			EnumMember = icons.get("list-unordered") .. " EnumMember",
			Constant = icons.get("constant") .. " Constant",
			Struct = icons.get("struct") .. " Struct",
		}
	else
		return {}
	end
end

return M
