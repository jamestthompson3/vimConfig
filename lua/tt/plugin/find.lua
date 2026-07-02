local M = {}
function M.init()
	vim.opt.wildmode = "noselect:lastused"
	vim.api.nvim_create_autocmd("CmdlineChanged", {
		pattern = ":",
		callback = function()
			vim.fn.wildtrigger()
		end,
	})
	local rg_args = { "rg", "--color", "never", "--files", "--hidden", "-g", "!.git" }

	local fd_cache = nil
	-- Prewarm asynchronously so the blocking path below is rarely hit on keypress
	local function refresh_file_list()
		vim.system(rg_args, { text = true }, function(obj)
			if obj.code == 0 then
				fd_cache = vim.split(obj.stdout, "\n", { trimempty = true })
			end
		end)
	end

	local function get_file_list()
		if not fd_cache then
			-- Cache not ready yet (first open before prewarm finishes): block once
			fd_cache = vim.fn.systemlist(rg_args)
		end
		return fd_cache
	end

	refresh_file_list()
	vim.api.nvim_create_autocmd("DirChanged", {
		callback = function()
			fd_cache = nil
			refresh_file_list()
		end,
	})

	local pick = require("tt.pick")

	vim.api.nvim_create_user_command("F", function()
		pick.open(get_file_list(), {
			prompt = "Files",
			on_choice = function(file, _, action)
				vim.cmd(action .. " " .. vim.fn.fnameescape(file))
			end,
		})
	end, {})

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
			table.insert(items, { text = vim.fn.fnamemodify(info.name, ":."), value = info.bufnr })
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

	vim.ui.select = pick.select

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
