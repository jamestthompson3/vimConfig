local fn = vim.fn

local M = {}

local is_windows = require("tt.platform").is_windows

M.vim_util = {}

-- Update on LSP events to prevent client searches during each statusline redraw.
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

-- 'wrap' is window-local. Set it for each window that displays the buffer.
function M.vim_util.soft_wrap_on_flag(flag, group_name)
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = vim.api.nvim_create_augroup(group_name, { clear = true }),
		callback = function(ev)
			if not vim.b[ev.buf][flag] then
				return
			end
			vim.wo[ev.win].wrap = true
			vim.wo[ev.win].linebreak = true
			vim.wo[ev.win].breakindent = true
		end,
	})
end

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

M.nodejs = {}

function M.nodejs.get_node_bin(bin)
	return fn.stdpath("config") .. "/langservers/node_modules/.bin/" .. bin
end

---@param context? integer|string Buffer number or project directory.
function M.nodejs.directory(context)
	if type(context) == "string" and context ~= "" then
		return vim.fs.abspath(context)
	end
	local name = vim.api.nvim_buf_get_name(context or 0)
	return name ~= "" and not name:match("^%a[%w+.-]*://") and vim.fs.dirname(name) or fn.getcwd()
end

local function find_node_path(relative, context, exists)
	local function candidate(dir)
		local path = vim.fs.joinpath(dir, "node_modules", relative)
		return exists(path) and path or nil
	end
	if vim.g.nodeDir then
		local path = candidate(vim.g.nodeDir)
		if path then
			return path
		end
	end
	local dir = M.nodejs.directory(context)
	while dir do
		local path = candidate(dir)
		if path then
			return path
		end
		local parent = vim.fs.dirname(dir)
		dir = parent ~= dir and parent or nil
	end
	return candidate(fn.stdpath("config") .. "/langservers") or ""
end

-- Do not keep resolved paths. Package installation can change the nearest executable.
function M.nodejs.find_node_executable(bin, context)
	local name = is_windows and (bin .. ".cmd") or bin
	local path = find_node_path(".bin/" .. name, context, function(p)
		return fn.executable(p) == 1
	end)
	return path ~= "" and path or fn.exepath(name)
end

function M.nodejs.get_node_lib(lib, context)
	return find_node_path(lib, context, function(p)
		return vim.uv.fs_stat(p) ~= nil
	end)
end

function M.nodejs.root_dir(markers, binary)
	return function(buf, on_dir)
		local root = vim.fs.root(buf, markers) or M.nodejs.directory(buf)
		if not binary or M.nodejs.find_node_executable(binary, root) ~= "" then
			on_dir(root)
		end
	end
end

function M.nodejs.lsp_cmd(bin, args)
	return function(dispatchers, config)
		local cwd = config.root_dir or config.cmd_cwd or fn.getcwd()
		local executable = M.nodejs.find_node_executable(bin, cwd)
		assert(executable ~= "", "Cannot find " .. bin .. "; install it in the project, langservers/, or PATH")
		return vim.lsp.rpc.start(vim.list_extend({ executable }, args or {}), dispatchers, {
			cwd = config.cmd_cwd or cwd,
			env = config.cmd_env,
			detached = config.detached,
		})
	end
end

return M
