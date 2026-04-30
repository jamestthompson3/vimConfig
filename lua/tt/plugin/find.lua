local M = {}
function M.init()
	vim.opt.wildmode = "noselect:lastused"
	vim.api.nvim_create_autocmd("CmdlineChanged", {
		pattern = ":",
		callback = function()
			vim.fn.wildtrigger()
		end,
	})
	local fd_cache = nil
	local function get_file_list()
		if not fd_cache then
			fd_cache = vim.fn.systemlist({ "rg", "--color", "never", "--files", "--hidden", "-g", "!.git" })
		end
		return fd_cache
	end

	vim.api.nvim_create_autocmd({ "DirChanged", "BufNew" }, {
		callback = function()
			fd_cache = nil
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

	vim.keymap.set("n", "<leader>.", "<cmd>B<cr>")
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
