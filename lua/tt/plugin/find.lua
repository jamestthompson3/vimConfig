local M = {}
function M.init()
	vim.opt.wildmode = "noselect:lastused"
	vim.api.nvim_create_autocmd("CmdlineChanged", {
		pattern = ":",
		callback = function()
			vim.fn.wildtrigger()
		end,
	})
	local files = require("tt.files")
	files.setup()
	local pick = require("tt.pick")
	local request_id = 0

	vim.api.nvim_create_user_command("F", function(cmd)
		local cwd = vim.fn.getcwd()
		local dir = vim.fs.abspath(cmd.args ~= "" and cmd.args or cwd)
		local win, buf = vim.api.nvim_get_current_win(), vim.api.nvim_get_current_buf()
		request_id = request_id + 1
		local id = request_id
		if cmd.bang then
			files.invalidate()
		end
		files.get(dir, function(items, err)
			if
				id ~= request_id
				or not vim.api.nvim_win_is_valid(win)
				or vim.api.nvim_get_current_win() ~= win
				or vim.api.nvim_get_current_buf() ~= buf
				or vim.fn.getcwd() ~= cwd
			then
				return
			end
			if err then
				vim.notify("Files: " .. err, vim.log.levels.ERROR)
				return
			end
			local prefix = dir:gsub("/+$", "") .. "/"
			pick.open(items, {
				prompt = cmd.args ~= "" and ("Files: " .. cmd.args) or "Files",
				format_item = function(file)
					return file:sub(#prefix + 1)
				end,
				on_choice = function(file, _, action)
					vim.cmd(action .. " " .. vim.fn.fnameescape(file))
				end,
			})
		end)
	end, { nargs = "?", bang = true, complete = "dir", desc = "Find files (! refreshes cache)" })

	vim.api.nvim_create_user_command("B", function()
		local bufs = {}
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[b].buflisted then
				local name = vim.api.nvim_buf_get_name(b)
				if name ~= "" then
					table.insert(bufs, vim.fn.fnamemodify(name, ":."))
				end
			end
		end
		pick.open(bufs, {
			prompt = "Buffers",
			on_choice = function(buf_name, _, action)
				vim.cmd(action .. " " .. vim.fn.fnameescape(buf_name))
			end,
		})
	end, {})

	vim.api.nvim_create_user_command("Marks", function()
		local marks = {}
		local buf_marks = vim.fn.getmarklist("%")
		local global_marks = vim.fn.getmarklist()

		for _, m in ipairs(buf_marks) do
			local mark = m.mark:sub(2)
			if mark:match("[a-z]") then
				local lnum = m.pos[2]
				local lines = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)
				local text = lines[1] and vim.trim(lines[1]) or ""
				table.insert(marks, { display = mark .. "  " .. lnum .. ": " .. text, mark = mark })
			end
		end

		for _, m in ipairs(global_marks) do
			local mark = m.mark:sub(2)
			if mark:match("[A-Z]") then
				local file = vim.fn.fnamemodify(m.file or "", ":~:.")
				local lnum = m.pos[2]
				table.insert(marks, { display = mark .. "  " .. file .. ":" .. lnum, mark = mark })
			end
		end

		if #marks == 0 then
			vim.notify("No marks set", vim.log.levels.INFO)
			return
		end

		pick.open(marks, {
			prompt = "Marks",
			format_item = function(item)
				return item.display
			end,
			on_choice = function(item, _, action)
				vim.cmd(action .. " | normal! `" .. item.mark)
			end,
		})
	end, {})

	vim.api.nvim_create_user_command("Recent", function()
		local cur = vim.api.nvim_get_current_buf()
		local infos = {}
		for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
			if info.name ~= "" and info.bufnr ~= cur then
				table.insert(infos, info)
			end
		end
		table.sort(infos, function(a, b)
			return a.lastused > b.lastused
		end)

		local items = {}
		for _, info in ipairs(infos) do
			local rel = vim.fn.fnamemodify(info.name, ":.")
			local dir = vim.fn.fnamemodify(rel, ":h")
			-- filename first (scannable column), containing dir dimmed alongside
			table.insert(items, {
				text = vim.fn.fnamemodify(rel, ":t"),
				hint = dir ~= "." and dir or nil,
				value = info.bufnr,
			})
		end
		if #items == 0 then
			vim.notify("No recent buffers", vim.log.levels.INFO)
			return
		end

		pick.numbered(items, {
			prompt = "Recent",
			on_choice = function(bufnr, action)
				if action == "edit" then
					vim.cmd("buffer " .. bufnr)
				else
					vim.cmd(action .. " | buffer " .. bufnr)
				end
			end,
			on_delete = function(bufnr)
				if not pcall(vim.cmd, "bdelete " .. bufnr) then
					vim.notify("Can't delete buffer (unsaved changes?)", vim.log.levels.WARN)
				end
			end,
		})
	end, {})

	vim.keymap.set("n", "<leader>.", "<cmd>Recent<cr>")
	vim.keymap.set("n", ",", "<cmd>F<cr>")

	vim.keymap.set("n", "<space>c", function()
		vim.ui.input({}, function(c)
			if c and c ~= "" then
				vim.cmd("noswapfile vnew")
				vim.bo.buftype = "nofile"
				vim.bo.bufhidden = "wipe"
				vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(c))
			end
		end)
	end)
end

return M
