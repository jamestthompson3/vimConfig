--- NVIM SPECIFIC SHORTCUTS
local vim = vim or {}
local api = vim.api
local fn = vim.fn
local loop = vim.uv

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

local is_windows = loop.os_uname().version:match("Windows")
-- set up globals based on current env
local GLOBALS = {}

if is_windows then
	GLOBALS.home = os.getenv("HOMEPATH")
	GLOBALS.cwd = function()
		local env_var = os.getenv("PWD")
		if env_var ~= nil then
			return env_var
		else
			return os.capture("echo %CD%")
		end
	end
	GLOBALS.python_host = "C:\\Users\\taylor.thompson\\AppData\\Local\\Programs\\Python\\Python36-32\\python.exe"
	GLOBALS.file_separator = "\\"
else
	GLOBALS.home = os.getenv("HOME")
	GLOBALS.cwd = function()
		return os.getenv("PWD")
	end
	GLOBALS.python_host = "/opt/homebrew/bin/python3"
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
	local formatted_cmd = ("<Cmd>%s<CR>"):format(cmd_string)
	set_nore(mode, lhs, formatted_cmd, vim.tbl_extend("force", { silent = true }, opts or {}))
end

function M.keys.map_no_cr(mode, lhs, cmd_string)
	local formatted_cmd = (":%s"):format(cmd_string)
	set_nore(mode, lhs, formatted_cmd)
end

function M.keys.map_call(mode, lhs, cmd_string, opts)
	local formatted_cmd = ("%s<CR>"):format(cmd_string)
	set_nore(mode, lhs, formatted_cmd, opts)
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

M.vim_util = {}

function M.vim_util.create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_create_augroup(group_name, { clear = true })
		for _, def in ipairs(definition) do
			vim.api.nvim_create_autocmd(def[1], def[2])
		end
	end
end

function M.vim_util.get_lsp_clients()
	local lsp = vim.lsp
	if vim.tbl_isempty(lsp.get_clients({ bufnr = 0 })) then
		return ""
	end
	local clients = {}
	for _, client in ipairs(lsp.get_clients({ bufnr = 0 })) do
		table.insert(clients, client.name)
	end
	return table.concat(clients, " • ")
end

function M.vim_util.get_diagnostics()
	local diags = vim.diagnostic.get(0)
	local warnings = 0
	local errors = 0
	if diags == nil then
		return ""
	end
	for _, diag in ipairs(diags) do
		if diag.severity == 1 then
			errors = errors + 1
		elseif diag.severity == 2 then
			warnings = warnings + 1
		end
	end
	if errors == 0 and warnings == 0 then
		return ""
	else
		return "(" .. errors .. "E" .. " • " .. warnings .. "W)"
	end
end

function M.vim_util.shell_to_buf(opts)
	local buf = api.nvim_create_buf(false, true)
	local cmd = table.concat(opts, " ")
	local result = vim.system({ cmd }):wait()
	local lines = vim.split(result.stdout or "", "\n")
	api.nvim_buf_set_lines(buf, 0, -1, true, lines)
	return buf
end

---
-- MISC UTILS
---

M.nodejs = {}

-- find vim related node_modules
function M.nodejs.get_node_bin(bin)
	return fn.stdpath("config") .. "/langservers/node_modules/.bin/" .. bin
end

function M.nodejs.find_node_executable(binaryName)
	local executable = fn.getcwd() .. "/node_modules/.bin/" .. binaryName
	local normalized_bin_name
	if is_windows then
		normalized_bin_name = binaryName .. ".cmd"
	else
		normalized_bin_name = binaryName
	end
	if 0 == fn.executable(executable) then
		local sub_cmd = fn.system("git rev-parse --show-toplevel")
		local project_root_path = sub_cmd:gsub("\n", "")
		executable = project_root_path .. "/node_modules/.bin/" .. normalized_bin_name
	end

	if 0 == fn.executable(executable) then
		executable = M.nodejs.get_node_bin(normalized_bin_name)
	end
	if 0 == fn.executable(executable) then
		-- log("Could not find " .. executable)
		return ""
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

function M.hl_search_match(blinktime)
	-- Get the pattern that matches the cursor position and last search pattern
	local pattern = [[\c\%#]] .. vim.fn.getreg("/")
	local match_id = vim.fn.matchadd("DiffDelete", pattern, 101)
	vim.cmd("redraw")
	vim.defer_fn(function()
		pcall(vim.fn.matchdelete, match_id)
		vim.cmd("redraw")
	end, blinktime * 1000)
end

return M
