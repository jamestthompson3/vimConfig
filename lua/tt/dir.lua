-- The directory buffer name is its path. Each line is an entry name.
-- The browser encodes newlines in entry names as NUL.

local M = {}
local api = vim.api

local function current_dir()
	return api.nvim_buf_get_name(0)
end

---@return string? name, boolean? is_dir
local function entry_under_cursor()
	local line = api.nvim_get_current_line()
	if line == "" then
		return nil
	end
	local is_dir = line:sub(-1) == "/"
	local name = (is_dir and line:sub(1, -2) or line):gsub("%z", "\n")
	if name == "" then
		return nil
	end
	return name, is_dir
end

local function reload(select_name)
	vim.api.nvim_exec_autocmds("User", { pattern = "TTFilesChanged" })
	require("tt.compat").reload_directory(vim.api.nvim_get_current_buf())
	if select_name and select_name ~= "" then
		vim.fn.search("\\V" .. vim.fn.escape(select_name, "\\"), "cw")
	end
end

-- Reload file metadata after a rename to prevent E13 on save.
-- nvim_buf_set_name can create an unloaded buffer for the old path.
local function rename_buffers(src, dst)
	src, dst = vim.fs.normalize(src), vim.fs.normalize(dst)
	local prefix = src .. "/"
	for _, buf in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_valid(buf) then
			local name = vim.fs.normalize(api.nvim_buf_get_name(buf))
			local newname
			if name == src then
				newname = dst
			elseif vim.startswith(name, prefix) then
				newname = dst .. name:sub(#src + 1)
			end
			if newname then
				local loaded = api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == ""
				local lines = loaded and vim.bo[buf].modified and api.nvim_buf_get_lines(buf, 0, -1, false) or nil
				pcall(api.nvim_buf_set_name, buf, newname)
				for _, other in ipairs(api.nvim_list_bufs()) do
					if
						other ~= buf
						and vim.fs.normalize(api.nvim_buf_get_name(other)) == name
						and not api.nvim_buf_is_loaded(other)
					then
						pcall(api.nvim_buf_delete, other, { force = true })
					end
				end
				if loaded then
					api.nvim_buf_call(buf, function()
						vim.cmd("silent! keepalt keepjumps edit!")
					end)
					if lines then
						api.nvim_buf_set_lines(buf, 0, -1, false, lines)
					end
				end
			end
		end
	end
end

local function wipe_buffers(path)
	path = vim.fs.normalize(path)
	local prefix = path .. "/"
	for _, buf in ipairs(api.nvim_list_bufs()) do
		if api.nvim_buf_is_valid(buf) then
			local name = vim.fs.normalize(api.nvim_buf_get_name(buf))
			if name == path or vim.startswith(name, prefix) then
				pcall(api.nvim_buf_delete, buf, { force = true })
			end
		end
	end
end

function M.create()
	local dir = current_dir()
	vim.ui.input({ prompt = "Create (trailing / = directory): ", completion = "file" }, function(input)
		if not input or input == "" then
			return
		end
		local path = vim.fs.joinpath(dir, input)
		if input:sub(-1) == "/" then
			vim.fs.mkdir(path, { parents = true })
		else
			vim.fs.mkdir(vim.fs.dirname(path), { parents = true })
			if not vim.uv.fs_stat(path) then
				local fd = vim.uv.fs_open(path, "w", tonumber("644", 8))
				if fd then
					vim.uv.fs_close(fd)
				end
			end
		end
		reload(vim.fs.basename((input:gsub("/+$", ""))))
	end)
end

function M.rename()
	local name = entry_under_cursor()
	if not name then
		return
	end
	local src = vim.fs.joinpath(current_dir(), name)
	vim.ui.input({ prompt = "Rename to: ", default = name, completion = "file" }, function(input)
		if not input or input == "" or input == name then
			return
		end
		local dst = vim.fs.joinpath(current_dir(), input)
		vim.fs.mkdir(vim.fs.dirname(dst), { parents = true })
		local ok, err = vim.uv.fs_rename(src, dst)
		if not ok then
			vim.notify("dir: rename failed: " .. tostring(err), vim.log.levels.ERROR)
			return
		end
		rename_buffers(src, dst)
		reload(vim.fs.basename((input:gsub("/+$", ""))))
	end)
end

function M.delete()
	local name, is_dir = entry_under_cursor()
	if not name then
		return
	end
	local path = vim.fs.joinpath(current_dir(), name)
	if vim.fn.confirm(("Delete %s %s?"):format(is_dir and "directory" or "file", name), "&Yes\n&No", 2) ~= 1 then
		return
	end
	if vim.fn.delete(path, is_dir and "rf" or "") ~= 0 then
		vim.notify("dir: failed to delete " .. name, vim.log.levels.ERROR)
		return
	end
	wipe_buffers(path)
	reload()
end

function M.setup()
	local group = vim.api.nvim_create_augroup("tt_dir_actions", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "directory",
		callback = function(ev)
			local function map(lhs, fn, desc)
				vim.keymap.set("n", lhs, fn, { buf = ev.buf, silent = true, nowait = true, desc = desc })
			end
			map("o", M.create, "dir: create file/dir")
			map("r", M.rename, "dir: rename entry")
			map("dd", M.delete, "dir: delete entry")
		end,
	})

	-- The browser sets 'buflisted' on each render, including reloads.
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "DirReadPost",
		desc = "dir: keep directory listings out of the buffer list",
		callback = function()
			vim.bo.buflisted = false
		end,
	})
end

return M
