local fn = vim.fn

local M = {}

local is_windows = require("tt.platform").is_windows

function _G.log(item)
	print(vim.inspect(item))
end

M.vim_util = {}

-- Return the first window displaying `buf`, or nil.
function M.vim_util.win_for_buf(buf)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			return win
		end
	end
end

-- Recompute the cached client list for `bufnr`. Called from LspAttach/LspDetach
-- so the statusline reads a buffer var instead of scanning clients each redraw.
function M.vim_util.refresh_lsp_clients(bufnr)
	bufnr = bufnr or 0
	local names = {}
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		names[#names + 1] = client.name
	end
	vim.b[bufnr].lsp_clients_str = table.concat(names, " • ")
end

function M.vim_util.get_lsp_clients()
	return vim.b.lsp_clients_str or ""
end

-- Soft-wrap (word boundaries, hanging indent) any window that displays a buffer
-- flagged with buffer-var `flag`. wrap is window-local, so key off BufWinEnter.
function M.vim_util.soft_wrap_on_flag(flag, group_name)
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = vim.api.nvim_create_augroup(group_name, { clear = true }),
		callback = function(ev)
			if not vim.b[ev.buf][flag] then
				return
			end
			local win = vim.fn.bufwinid(ev.buf)
			if win ~= -1 then
				vim.wo[win].wrap = true
				vim.wo[win].linebreak = true
				vim.wo[win].breakindent = true
			end
		end,
	})
end

-- Open `lines` in a bottom-split scratch buffer. opts: filetype, buftype
-- (default "nofile"), bufhidden (default "wipe"), modifiable, name. Returns buf.
function M.vim_util.scratch_split(lines, opts)
	opts = opts or {}
	vim.cmd("botright split")
	vim.cmd("enew")
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].buftype = opts.buftype or "nofile"
	vim.bo[buf].bufhidden = opts.bufhidden or "wipe"
	if opts.filetype then
		vim.bo[buf].filetype = opts.filetype
	end
	if opts.name then
		pcall(vim.api.nvim_buf_set_name, buf, opts.name)
	end
	if opts.modifiable == false then
		vim.bo[buf].modifiable = false
	end
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
		return vim.fn.executable(path) == 1
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
