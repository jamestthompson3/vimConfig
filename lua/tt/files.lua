local M = {}
local entries = {}
local args = { "rg", "--color", "never", "--files", "--hidden", "-0", "-g", "!.git" }

local function directory(dir)
	return vim.fs.normalize(vim.fs.abspath(dir or vim.fn.getcwd()))
end

local scan
scan = function(dir, entry)
	entry.generation = entry.generation + 1
	local generation = entry.generation
	entry.pending = true
	local function finish(result)
		vim.schedule(function()
			if entry.generation ~= generation then
				return
			end
			entry.pending = false
			local err
			if result.code == 0 or result.code == 1 then
				entry.files = vim.tbl_map(function(file)
					return vim.fs.joinpath(dir, file)
				end, vim.split(result.stdout or "", "\0", { plain = true, trimempty = true }))
			else
				err = vim.trim(result.stderr or "file scan failed")
			end
			local waiters = entry.waiters
			entry.waiters = {}
			for _, cb in ipairs(waiters) do
				cb(entry.files, err)
			end
		end)
	end
	local ok, err = pcall(vim.system, args, { cwd = dir, text = true, timeout = 10000 }, finish)
	if not ok then
		finish({ code = -1, stderr = tostring(err) })
	end
end

function M.get(dir, cb)
	dir = directory(dir)
	local entry = entries[dir]
	if not entry then
		entry = { generation = 0, waiters = {} }
		entries[dir] = entry
	end
	if entry.files then
		local files = entry.files
		vim.schedule(function()
			cb(files)
		end)
		return
	end
	entry.waiters[#entry.waiters + 1] = cb
	if not entry.pending then
		scan(dir, entry)
	end
end

function M.invalidate()
	for dir, entry in pairs(entries) do
		entry.files = nil
		entry.generation = entry.generation + 1
		entry.pending = false
		if #entry.waiters > 0 then
			scan(dir, entry)
		end
	end
end

function M.setup()
	local group = vim.api.nvim_create_augroup("tt_file_cache", { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufFilePost", "FileChangedShellPost", "FocusGained" }, {
		group = group,
		callback = M.invalidate,
	})
	vim.api.nvim_create_autocmd("User", { group = group, pattern = "TTFilesChanged", callback = M.invalidate })
	vim.api.nvim_create_autocmd("DirChanged", {
		group = group,
		callback = function()
			M.get(vim.fn.getcwd(), function() end)
		end,
	})
	M.get(vim.fn.getcwd(), function() end)
end

return M
