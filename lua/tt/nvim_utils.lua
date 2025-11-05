--- NVIM SPECIFIC SHORTCUTS
local vim = vim or {}
local api = vim.api
local fn = vim.fn

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

local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
-- set up globals based on current env
local GLOBALS = {}

if is_windows then
	GLOBALS.home = os.getenv("HOMEPATH")
	GLOBALS.python_host = "C:\\Users\\taylor.thompson\\AppData\\Local\\Programs\\Python\\Python36-32\\python.exe"
else
	GLOBALS.home = os.getenv("HOME")
	GLOBALS.python_host = "/opt/homebrew/bin/python3"
end

M.GLOBALS = GLOBALS

function log(item)
	print(vim.inspect(item))
end

M.vim_util = {}

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

function M.vim_util.shell_to_buf(cmd)
	local buf = api.nvim_create_buf(false, true)
	local result = vim.system(cmd):wait()
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
	local normalized_bin_name
	local executable = ""
	if is_windows then
		normalized_bin_name = binaryName .. ".cmd"
	else
		normalized_bin_name = binaryName
	end

	local function is_executable(path)
		local stat = vim.uv.fs_stat(path)
		if not stat then
			return false
		end
		return vim.fn.executable(path)
	end

	if vim.g.nodeDir ~= nil then
		executable = vim.g.nodeDir .. "/node_modules/.bin/" .. normalized_bin_name
	end
	if not is_executable(executable) then
		executable = fn.getcwd() .. "/node_modules/.bin/" .. normalized_bin_name
	end
	if not is_executable(executable) then
		local result = vim.system({ "git", "rev-parse", "--show-toplevel" }):wait()
		if result.code == 0 then
			local project_root_path = vim.trim(result.stdout)
			executable = vim.fs.normalize(project_root_path .. "/node_modules/.bin/" .. normalized_bin_name)
		end
	end

	if not is_executable(executable) then
		executable = M.nodejs.get_node_bin(normalized_bin_name)
	end
	if not is_executable(executable) then
		return ""
	end
	return executable
end

function M.nodejs.get_node_lib(lib)
	local f = fn.getcwd() .. "/node_modules/" .. lib
	if not vim.uv.fs_stat(f) then
		local result = vim.system({ "git", "rev-parse", "--show-toplevel" }):wait()
		if result.code == 0 then
			local project_root_path = vim.trim(result.stdout)
			f = vim.fs.normalize(project_root_path .. "/node_modules/" .. lib)
		end
	end
	if vim.uv.fs_stat(f) then
		return f
	end
	return ""
end

function M.vim_util.iabbrev(src, target, buffer)
	if buffer == nil then
		vim.cmd.iabbrev({ args = { src, target } })
	else
		vim.cmd.iabbrev({ args = { "<buffer>", src, target } })
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
