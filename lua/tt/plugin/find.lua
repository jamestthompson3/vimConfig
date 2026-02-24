local M = {}
function M.init()
	local fzf = require("fzf-lua")
	fzf.register_ui_select()
	fzf.setup({
		"max-perf",
		fzf_bin = "sk",
		winopts = { preview = { hidden = true } },
		files = { line_query = false },
		fzf_opts = { ["--algo"] = "frizbee" },
		-- fzf_opts = { ["--scheme"] = "path", ["--tiebreak"] = "index" },
	})
	vim.keymap.set("n", ",", "<Cmd>FzfLua files<CR>")
	vim.keymap.set("n", "<leader>.", "<Cmd>FzfLua buffers<CR>")
	-- function _G.RgFindFiles(cmdarg)
	-- 	local fnames = vim.fn.systemlist({ "fd", "--color", "never", "--type", "f", "--hidden" })
	-- 	if #cmdarg == 0 then
	-- 		return fnames
	-- 	else
	-- 		return vim.fn.matchfuzzy(fnames, cmdarg)
	-- 	end
	-- end
	--
	-- vim.o.findfunc = "v:lua.RgFindFiles"
	--
	local function is_cmdline_type_find()
		local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]

		return cmdline_cmd == "find" or cmdline_cmd == "fin" or cmdline_cmd == "sf"
	end
	--
	-- vim.api.nvim_create_autocmd({ "CmdlineChanged", "CmdlineLeave" }, {
	-- 	pattern = { "*" },
	-- 	group = vim.api.nvim_create_augroup("CmdlineAutocompletion", { clear = true }),
	-- 	callback = function(ev)
	-- 		local function should_enable_autocomplete()
	-- 			local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), " ")[1]
	--
	-- 			return is_cmdline_type_find() or cmdline_cmd == "help" or cmdline_cmd == "h"
	-- 		end
	--
	-- 		if ev.event == "CmdlineChanged" and should_enable_autocomplete() then
	-- 			vim.opt.wildmode = "noselect:lastused,full"
	-- 			vim.fn.wildtrigger()
	-- 		end
	--
	-- 		if ev.event == "CmdlineLeave" then
	-- 			vim.opt.wildmode = "full"
	-- 		end
	-- 	end,
	-- })
	--
	-- vim.keymap.set("n", ",", ":find<space>")
	vim.keymap.set("c", "<C-y>", function()
		local keys
		if is_cmdline_type_find() then
			keys = vim.api.nvim_replace_termcodes("<home><s-right><c-w>edit<end><CR>", true, true, true)
		else
			keys = vim.api.nvim_replace_termcodes("<CR>", true, true, true)
		end
		vim.fn.feedkeys(keys, "c")
	end)
	-- vim.keymap.set("c", "<C-v>", function()
	-- 	if is_cmdline_type_find() then
	-- 		local keys = vim.api.nvim_replace_termcodes("<home><s-right><c-w>vsplit<end><CR>", true, true, true)
	-- 		vim.fn.feedkeys(keys, "c")
	-- 	end
	-- end)
	-- vim.keymap.set("c", "<C-s>", function()
	-- 	if is_cmdline_type_find() then
	-- 		local keys = vim.api.nvim_replace_termcodes("<home><s-right><c-w>split<end><CR>", true, true, true)
	-- 		vim.fn.feedkeys(keys, "c")
	-- 	end
	-- end)
	-- vim.keymap.set("n", "<leader>.", ":b<space>")

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
