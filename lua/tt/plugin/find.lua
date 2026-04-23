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

	vim.api.nvim_create_autocmd({ "DirChanged", "BufWritePost" }, {
		callback = function()
			fd_cache = nil
		end,
	})

	local pick = require("tt.pick")

	vim.api.nvim_create_user_command("F", function()
		pick.open(get_file_list(), {
			prompt = "F",
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
			prompt = "B",
			on_choice = function(buf_name, _, action)
				vim.cmd(action .. " " .. vim.fn.fnameescape(buf_name))
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
