local vim = vim or {}
local fn = vim.fn

local M = {}

local is_windows = vim.uv.os_uname().sysname == "Windows_NT"

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

---
-- MISC UTILS
---

M.nodejs = {}

-- find vim related node_modules
function M.nodejs.get_node_bin(bin)
	return fn.stdpath("config") .. "/langservers/node_modules/.bin/" .. bin
end

function M.nodejs.find_node_executable(binaryName, bufnr)
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

	-- 1. Check vim.g.nodeDir override
	if vim.g.nodeDir ~= nil then
		executable = vim.g.nodeDir .. "/node_modules/.bin/" .. normalized_bin_name
	end

	-- 2. Walk up from the file's directory to find nearest node_modules
	if not is_executable(executable) then
		local buf = bufnr or 0
		local bufname = vim.api.nvim_buf_get_name(buf)
		if bufname and bufname ~= "" then
			local file_dir = vim.fn.fnamemodify(bufname, ":h")
			local found = vim.fs.find("node_modules", {
				path = file_dir,
				upward = true,
				type = "directory",
			})
			if found and #found > 0 then
				executable = found[1] .. "/.bin/" .. normalized_bin_name
			end
		end
	end

	-- 3. Check cwd
	if not is_executable(executable) then
		executable = fn.getcwd() .. "/node_modules/.bin/" .. normalized_bin_name
	end

	-- 4. Check git root
	if not is_executable(executable) then
		local git_root = vim.fs.root(0, ".git")
		if git_root then
			executable = vim.fs.normalize(git_root .. "/node_modules/.bin/" .. normalized_bin_name)
		end
	end

	-- 5. Fallback to langservers
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
		local git_root = vim.fs.root(0, ".git")
		if git_root then
			f = vim.fs.normalize(git_root .. "/node_modules/" .. lib)
		end
	end
	if vim.uv.fs_stat(f) then
		return f
	end
	-- Fallback to langservers
	local langservers_path = fn.stdpath("config") .. "/langservers/node_modules/" .. lib
	if vim.uv.fs_stat(langservers_path) then
		return langservers_path
	end
	return ""
end

return M
