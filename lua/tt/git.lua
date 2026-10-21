local M = {}
local api = vim.api
local fn = vim.fn
local namespace = api.nvim_create_namespace("git_lens")

local function teardown(work_buf, head_buf)
	for _, w in ipairs(api.nvim_tabpage_list_wins(0)) do
		if api.nvim_win_get_buf(w) == work_buf then
			api.nvim_set_current_win(w)
			break
		end
	end
	vim.cmd("diffoff!")
	vim.cmd("only")
	if head_buf and api.nvim_buf_is_valid(head_buf) then
		pcall(api.nvim_buf_delete, head_buf, { force = true })
	end
end

function M.diff(file)
	vim.cmd.packadd("nvim.difftool")
	local relpath = file or fn.expand("%")
	local fullpath = fn.fnamemodify(relpath, ":p")
	local ext = fn.fnamemodify(relpath, ":e")
	local tmpfile = fn.tempname() .. "." .. ext
	vim.system({ "git", "show", "HEAD:" .. relpath }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				vim.notify("Not in git or no HEAD version", vim.log.levels.WARN)
				return
			end
			vim.fn.writefile(vim.split(result.stdout, "\n"), tmpfile)

			require("difftool").open(tmpfile, fullpath)

			local work_buf = fn.bufnr(fullpath)
			local head_buf = fn.bufnr(tmpfile)
			if head_buf ~= -1 then
				-- make the HEAD snapshot obviously disposable + unsaveable
				vim.bo[head_buf].buftype = "nofile"
				vim.bo[head_buf].bufhidden = "wipe"
				vim.bo[head_buf].modifiable = false
				vim.bo[head_buf].readonly = true
				pcall(api.nvim_buf_set_name, head_buf, "HEAD:" .. relpath)
			end
			for _, b in ipairs({ work_buf, head_buf }) do
				if b ~= -1 then
					vim.keymap.set("n", "q", function()
						teardown(work_buf, head_buf)
					end, { buffer = b, desc = "Close diff, return to working file" })
				end
			end
		end)
	end)
end

function M.blame_file()
	local fileName = fn.expand("%")
	vim.system({ "git", "blame", fileName }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				vim.notify("git blame: " .. (result.stderr or ""), vim.log.levels.ERROR)
				return
			end
			local buf = api.nvim_create_buf(false, true)
			api.nvim_buf_set_lines(buf, 0, -1, true, vim.split(result.stdout, "\n"))
			vim.cmd("40wincmd v")
			vim.cmd.wincmd("r")
			api.nvim_win_set_buf(0, buf)
			vim.bo.filetype = "fugitiveblame"
			vim.cmd.wincmd("h")
		end)
	end)
end

function M.blame()
	local ft = fn.expand("%:h:t")
	if ft == "" or ft == "bin" then
		return
	end
	api.nvim_buf_clear_namespace(0, namespace, 0, -1)
	local buf = api.nvim_get_current_buf()
	local currFile = fn.expand("%")
	local line = api.nvim_win_get_cursor(0)
	vim.system({
		"git",
		"log",
		"-1",
		"--format=%an, %ar • %s",
		"-L",
		string.format("%d,%d:%s", line[1], line[1], currFile),
	}, { text = true }, function(result)
		if result.code ~= 0 or not result.stdout or result.stdout == "" then
			return
		end
		local text = vim.split(result.stdout, "\n")
		vim.schedule(function()
			-- The cursor may have moved (which also clears the blame) before git
			-- returned; only draw if we're still on the line we asked about.
			if not api.nvim_buf_is_valid(buf) or api.nvim_get_current_buf() ~= buf then
				return
			end
			if api.nvim_win_get_cursor(0)[1] ~= line[1] then
				return
			end
			api.nvim_buf_set_extmark(buf, namespace, line[1] - 1, line[2], {
				virt_text = { { text[1], "GitLens" } },
			})
			api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = api.nvim_create_augroup("git_blame_clear", { clear = true }),
				once = true,
				callback = function()
					if api.nvim_buf_is_valid(buf) then
						api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
					end
				end,
			})
		end)
	end)
end

-- Open the current file on the remote (GitHub) at the cursor line, or at the
-- selected range in visual mode. The URL is also copied to the + register so
-- it can be shared. Relies on the `git-open --blob --line` extension.
function M.open()
	local file = fn.expand("%:p")
	if file == "" then
		vim.notify("No file to open", vim.log.levels.WARN)
		return
	end
	local dir = fn.fnamemodify(file, ":h")

	local toplevel = vim.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }, { text = true }):wait()
	if toplevel.code ~= 0 then
		vim.notify("Not in a git repository", vim.log.levels.WARN)
		return
	end
	-- path from repo root, which is what `git-open --blob` expects
	local relpath = file:sub(#vim.trim(toplevel.stdout) + 2)

	local line
	local mode = api.nvim_get_mode().mode
	if mode == "v" or mode == "V" or mode == "\22" then
		-- visual: use the selection start/end lines
		local lo = fn.line("v")
		local hi = fn.line(".")
		if lo > hi then
			lo, hi = hi, lo
		end
		line = lo == hi and tostring(lo) or string.format("%d-%d", lo, hi)
		api.nvim_feedkeys(api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	else
		line = tostring(api.nvim_win_get_cursor(0)[1])
	end

	vim.system(
		{ "git-open", "--print", "--blob=" .. relpath, "--line=" .. line },
		{ cwd = dir, text = true },
		function(result)
			vim.schedule(function()
				if result.code ~= 0 then
					vim.notify(vim.trim(result.stderr or "git-open failed"), vim.log.levels.ERROR)
					return
				end
				local url = vim.trim(result.stdout)
				fn.setreg("+", url)
				vim.ui.open(url)
				vim.notify(url)
			end)
		end
	)
end

function M.branch()
	local result = vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }):wait()
	if result.code == 0 and result.stdout then
		return vim.trim(result.stdout)
	end
	return ""
end

local function listChangedFiles()
	local result = vim.system({ "git", "diff", "--name-only", "--no-color" }):wait()
	if result.code == 0 and result.stdout then
		return vim.split(vim.trim(result.stdout), "\n")
	else
		return {}
	end
end

local function jumpToDiff()
	M.diff(fn.expand("<cfile>"))
end

function M.changedFiles()
	vim.cmd.tabnew()
	local files = listChangedFiles()
	local buf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(buf, 0, -1, true, files)
	api.nvim_win_set_buf(0, buf)
	vim.keymap.set("n", "<CR>", jumpToDiff, { buffer = buf })
	vim.keymap.set("n", "Q", ":tabclose<CR>", { buffer = buf })
end

return M
