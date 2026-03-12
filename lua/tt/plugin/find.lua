local M = {}
function M.init()
	-- local fzf = require("fzf-lua")
	-- fzf.register_ui_select()
	-- fzf.setup({
	-- 	"max-perf",
	-- 	fzf_bin = "sk",
	-- 	winopts = { preview = { hidden = true } },
	-- 	files = { line_query = false },
	-- 	fzf_opts = { ["--algo"] = "frizbee" },
	-- 	-- fzf_opts = { ["--scheme"] = "path", ["--tiebreak"] = "index" },
	-- })
	-- vim.keymap.set("n", ",", "<Cmd>FzfLua files<CR>")
	-- vim.keymap.set("n", "<leader>.", "<Cmd>FzfLua buffers<CR>")

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

	-- Invalidate cache on directory change or when writing files
	vim.api.nvim_create_autocmd({ "DirChanged", "BufWritePost" }, {
		callback = function()
			fd_cache = nil
		end,
	})

	local function fuzzy_find_files(arglead)
		local fnames = get_file_list()
		if #arglead == 0 then
			return fnames
		end
		return vim.fn.matchfuzzy(fnames, arglead)
	end

	local function is_cmdline_type_find()
		local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]
		return cmdline_cmd == "F"
	end

	local function open_find_completion(cmd)
		local cmdline = vim.fn.getcmdline()
		local query = cmdline:match("^%S+%s+(.+)$") or ""
		local matches = fuzzy_find_files(query)
		local file = matches and matches[1]
		if file then
			vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n")
			vim.schedule(function()
				vim.cmd(cmd .. " " .. vim.fn.fnameescape(file))
			end)
		end
	end

	vim.api.nvim_create_user_command("F", function(opts)
		local matches = fuzzy_find_files(opts.args)
		if matches and matches[1] then
			vim.cmd("edit " .. vim.fn.fnameescape(matches[1]))
		end
	end, {
		nargs = "?",
		complete = function(_, cmdline)
			local query = cmdline:match("^%S+%s+(.*)$") or ""
			return fuzzy_find_files(query)
		end,
	})

	vim.keymap.set("c", "<C-y>", function()
		if is_cmdline_type_find() then
			open_find_completion("edit")
		else
			vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "c")
		end
	end)
	vim.keymap.set("c", "<C-v>", function()
		if is_cmdline_type_find() then
			open_find_completion("vsplit")
		end
	end)
	vim.keymap.set("c", "<C-s>", function()
		if is_cmdline_type_find() then
			open_find_completion("split")
		end
	end)
	vim.api.nvim_create_user_command("B", function(opts)
		vim.cmd("buffer " .. vim.fn.fnameescape(opts.args))
	end, {
		nargs = 1,
		complete = function(arglead)
			local bufs = {}
			for _, b in ipairs(vim.api.nvim_list_bufs()) do
				if vim.bo[b].buflisted then
					local name = vim.api.nvim_buf_get_name(b)
					if name ~= "" then
						table.insert(bufs, vim.fn.fnamemodify(name, ":."))
					end
				end
			end
			if #arglead == 0 then
				return bufs
			end
			return vim.fn.matchfuzzy(bufs, arglead)
		end,
	})
	vim.keymap.set("n", "<leader>.", ":B<space>")
	vim.keymap.set("n", ",", ":F<space>")

	-- temp move elsewhere
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
