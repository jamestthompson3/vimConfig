--- NVIM SPECIFIC SHORTCUTS
local vim = vim or {}
local api = vim.api
local fn = vim.fn
local loop = vim.loop

local M = {}

local valid_modes = {
	n = "n",
	v = "v",
	x = "x",
	i = "i",
	o = "o",
	t = "t",
	c = "c",
	s = "s",
	-- :map! and :map
	["!"] = "!",
	[" "] = "",
}

is_windows = loop.os_uname().version:match("Windows")
-- set up globals based on current env
local GLOBALS = {}

if is_windows then
	GLOBALS.home = os.getenv("HOMEPATH")
	GLOBALS.cwd = function()
		return os.getenv("cd")
	end
	GLOBALS.python_host = "C:\\Users\\taylor.thompson\\AppData\\Local\\Programs\\Python\\Python36-32\\python.exe"
	GLOBALS.file_separator = "\\"
else
	GLOBALS.home = os.getenv("HOME")
	GLOBALS.cwd = function()
		return os.getenv("PWD")
	end
	GLOBALS.python_host = "/usr/local/bin/python3"
	GLOBALS.file_separator = "/"
end

M.GLOBALS = GLOBALS

M.keys = {}

local function set(mode, tbl)
	assert(valid_modes[mode], "keymap set: invalid mode specified for keymapping. mode=" .. mode)
	vim.keymap.set(mode, tbl[1], tbl[2], tbl[3])
end

local function set_nore(mode, lhs, rhs, opts)
	assert(valid_modes[mode], "keymap set: invalid mode specified for keymapping. mode=" .. mode)
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("keep", { noremap = true }, opts or {}))
end

function M.keys.map_cmd(mode, lhs, cmd_string, opts)
	formatted_cmd = ("<Cmd>%s<CR>"):format(cmd_string)
	set_nore(mode, lhs, formatted_cmd, vim.tbl_extend("force", { silent = true }, opts or {}))
end

function M.keys.map_no_cr(mode, lhs, cmd_string)
	formatted_cmd = (":%s"):format(cmd_string)
	set_nore(mode, lhs, formatted_cmd)
end

function M.keys.map_call(mode, lhs, cmd_string, opts)
	formatted_cmd = ("%s<CR>"):format(cmd_string)
	set_nore(mode, lhs, formatted_cmd, opts)
end

function M.keys.nmap_call(lhs, cmd_string, opts)
	M.keys.map_call("n", lhs, cmd_string, opts)
end

function M.keys.nmap_cmd(lhs, cmd_string, opts)
	M.keys.map_cmd("n", lhs, cmd_string, opts)
end

function M.keys.xmap_cmd(lhs, cmd_string)
	M.keys.map_cmd("x", lhs, cmd_string)
end

function M.keys.nmap_nocr(lhs, cmd_string)
	M.keys.map_no_cr("n", lhs, cmd_string)
end

function M.keys.vmap_nocr(lhs, cmd_string)
	M.keys.map_no_cr("v", lhs, cmd_string)
end

function M.keys.nnore(lhs, rhs)
	set_nore("n", lhs, rhs)
end

function M.keys.inore(lhs, rhs)
	set_nore("i", lhs, rhs)
end

function M.keys.xnore(lhs, rhs)
	set_nore("x", lhs, rhs)
end

function M.keys.vnore(lhs, rhs)
	set_nore("v", lhs, rhs)
end

function M.keys.tnore(lhs, rhs)
	set_nore("t", lhs, rhs)
end

function M.keys.imap(tbl)
	set("i", tbl)
end

function M.keys.nmap(tbl)
	set("n", tbl)
end

function M.keys.vmap(tbl)
	set("v", tbl)
end

function M.keys.xmap(tbl)
	set("x", tbl)
end

function M.keys.cmap(tbl)
	set("c", tbl)
end

function M.keys.tmap(tbl)
	set("t", tbl)
end

function M.keys.buf_nnoremap(opts)
	if opts[3] == nil then
		opts[3] = {}
	end
	opts[3].buffer = 0

	M.keys.nmap(opts)
end

function M.keys.buf_inoremap(opts)
	if opts[3] == nil then
		opts[3] = {}
	end
	opts[3].buffer = 0

	M.keys.imap(opts)
end

function log(item)
	print(vim.inspect(item))
end

--- Check if a file or directory exists in this path
function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

--- Check if a directory exists in this path
function isdir(path)
	-- "/" works on both Unix and Windows
	return exists(path .. "/")
end

function getPath(str)
	local s = str:gsub("%-", "")
	return s:match("(.*[/\\])")
end

M.vim_util = {}

function M.vim_util.create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command("augroup " .. group_name)
		vim.api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command("augroup END")
	end
end

function M.vim_util.get_lsp_clients()
	local lsp = vim.lsp
	if vim.tbl_isempty(lsp.buf_get_clients(0)) then
		return ""
	end
	local clients = {}
	for _, client in ipairs(vim.lsp.buf_get_clients(0)) do
		table.insert(clients, client.name)
	end
	return table.concat(clients, " • ")
end

function M.vim_util.shell_to_buf(opts)
	local buf = api.nvim_create_buf(false, true)
	local lines = vim.split(os.capture(table.concat(opts, " "), true), "\n")
	api.nvim_buf_set_lines(buf, 0, -1, true, lines)
	return buf
end

---
-- Things Lua should've had
---

function string.startswith(s, n)
	return s:sub(1, #n) == n
end

function string.endswith(self, str)
	return self:sub(-#str) == str
end

---
-- SPAWN UTILS
---
--
local function safe_close(handle)
	if not loop.is_closing(handle) then
		loop.close(handle)
	end
end

function M.spawn(cmd, opts, input, onexit)
	local input = input or { stdout = function() end, stderr = function() end }
	local handle, pid
	local stdout = loop.new_pipe(false)
	local stderr = loop.new_pipe(false)
	handle, pid = loop.spawn(cmd, vim.tbl_extend("force", opts, { stdio = { stdout, stderr } }), function(code, signal)
		if type(onexit) == "function" then
			onexit(code, signal)
		end
		loop.read_stop(stdout)
		loop.read_stop(stderr)
		safe_close(handle)
		safe_close(stdout)
		safe_close(stderr)
	end)
	loop.read_start(stdout, input.stdout)
	loop.read_start(stderr, input.stderr)
end

--- MISC UTILS

-- capturs stdout as a string
function os.capture(cmd, raw, nosub)
	local f = assert(io.popen(cmd, "r"))
	local s = assert(f:read("*a"))
	f:close()
	if raw then
		return s
	end
	if nosub == nil then
		s = string.gsub(s, "^%s+", "")
		s = string.gsub(s, "%s+$", "")
		s = string.gsub(s, "[\n\r]+", " ")
	end
	return s
end

M.nodejs = {}

-- find vim related node_modules
function M.nodejs.get_node_bin(bin)
	return fn.stdpath("config") .. "/langservers/node_modules/.bin/" .. bin
end

function M.nodejs.find_node_executable(binaryName)
	local executable = fn.getcwd() .. "/node_modules/.bin/" .. binaryName
	if 0 == fn.executable(executable) then
		local sub_cmd = fn.system("git rev-parse --show-toplevel")
		local project_root_path = sub_cmd:gsub("\n", "")
		executable = project_root_path .. "/node_modules/.bin/" .. binaryName
	end

	if 0 == fn.executable(executable) then
		executable = M.nodejs.get_node_bin(binaryName)
	end
	if 0 == fn.executable(executable) then
		log("Could not find " .. executable)
		return
	end
	return executable
end

function M.vim_util.iabbrev(src, target, buffer)
	if buffer == nil then
		api.nvim_command("iabbrev " .. src .. " " .. target)
	else
		api.nvim_command("iabbrev <buffer> " .. src .. " " .. target)
	end
end

function augroup(name, commands)
	vim.cmd("augroup " .. name)
	vim.cmd("autocmd!")
	for _, c in ipairs(commands) do
		vim.cmd(
			string.format(
				"autocmd %s %s %s %s",
				table.concat(c.events, ","),
				table.concat(c.targets or {}, ","),
				table.concat(c.modifiers or {}, " "),
				c.command
			)
		)
	end
	vim.cmd("augroup END")
end

return M
