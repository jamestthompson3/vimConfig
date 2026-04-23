local M = {}

local ns = vim.api.nvim_create_namespace("tt_pick")

local ACCEPT, CANCEL, SPLIT, VSPLIT = 0, 1, 2, 3
local action_name = { [ACCEPT] = "edit", [SPLIT] = "split", [VSPLIT] = "vsplit" }

local active_co = nil
local picker_count = 0

local function setup_highlights()
	local hi = function(name, val)
		val.default = true
		vim.api.nvim_set_hl(0, name, val)
	end
	hi("PickNormal", { link = "NormalFloat" })
	hi("PickBorder", { link = "FloatBorder" })
	hi("PickPrompt", { link = "DiffChange" })
	hi("PickSel", { link = "PmenuSel" })
	hi("PickPointer", { link = "WildMenu" })
	hi("PickMatch", { link = "PmenuMatch" })
end

function M.open(items, opts)
	opts = opts or {}

	if active_co and coroutine.status(active_co) == "suspended" then
		coroutine.resume(active_co, CANCEL)
	end

	setup_highlights()

	local prompt_str = opts.prompt or "> "
	local on_choice = opts.on_choice or function() end
	local on_cancel = opts.on_cancel

	local norm = {}
	for i, item in ipairs(items) do
		local text = opts.format_item and opts.format_item(item) or type(item) == "string" and item or tostring(item)
		norm[i] = { id = i, text = text, value = item }
	end

	local input = ""
	local last_rendered_input = nil
	local matches = {}
	local idx = 0
	local offset = 0
	local closed = false
	local co, augroup, saved_view, saved_win

	local win_width = math.floor(vim.o.columns * 0.7)
	local win_col = math.floor((vim.o.columns - win_width) / 2)
	local function max_h()
		return math.ceil(vim.o.lines * (opts.height or 0.4))
	end
	local function list_max()
		return math.max(max_h() - 1, 1)
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	pcall(function()
		vim.bo[buf].autocomplete = false
	end)

	local initial_h = math.max(1, math.min(#items + 1, max_h()))
	local win = vim.api.nvim_open_win(buf, false, {
		relative = "editor",
		width = win_width,
		height = initial_h,
		row = math.floor((vim.o.lines - initial_h) / 2),
		col = win_col,
		style = "minimal",
		border = "rounded",
	})
	vim.wo[win].wrap = false
	vim.wo[win].cursorline = false
	vim.api.nvim_set_option_value(
		"winhighlight",
		"Normal:PickNormal,FloatBorder:PickBorder",
		{ scope = "local", win = win }
	)

	local function all_matches()
		local m = {}
		for i, item in ipairs(norm) do
			m[i] = { item.id, {}, 0 }
		end
		return m
	end
	matches = all_matches()
	idx = #matches > 0 and 1 or 0

	local function clamp()
		if #matches == 0 then
			idx = 0
		else
			idx = math.max(1, math.min(idx, #matches))
		end
	end

	local function update_offset()
		clamp()
		local lm = list_max()
		if idx == 0 then
			offset = 0
			return
		end
		if idx - lm > offset then
			offset = idx - lm
		end
		if idx <= offset then
			offset = idx - 1
		end
		offset = math.max(0, math.min(offset, #matches - lm))
	end

	local function render()
		if closed then
			return
		end

		local pointer = ">"
		local indent_n = #pointer + 1
		local prefix = (" "):rep(indent_n)
		local lm = list_max()

		update_offset()

		local lines = { input }
		local all_pos = {}
		for i = 1 + offset, math.min(#matches, lm + offset) do
			local m = matches[i]
			lines[#lines + 1] = prefix .. norm[m[1]].text
			all_pos[#all_pos + 1] = m[2]
		end
		local match_count = #lines - 1

		last_rendered_input = input

		vim._with({ noautocmd = true }, function()
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		end)

		pcall(vim.api.nvim_win_set_config, win, {
			relative = "editor",
			row = math.floor((vim.o.lines - initial_h) / 2),
			col = win_col,
			height = initial_h,
			width = win_width,
		})

		vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

		for i = 1, match_count do
			for _, c in ipairs(all_pos[i] or {}) do
				pcall(vim.api.nvim_buf_set_extmark, buf, ns, i, indent_n + c, {
					end_col = indent_n + c + 1,
					hl_group = "PickMatch",
					hl_mode = "combine",
				})
			end
		end

		if idx > 0 and match_count > 0 then
			local row = idx - offset
			if row >= 1 and row <= match_count then
				vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
					virt_text = { { pointer, "PickPointer" } },
					virt_text_pos = "overlay",
					hl_mode = "combine",
				})
				vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
					hl_group = "PickSel",
					hl_eol = true,
					end_row = row + 1,
					hl_mode = "combine",
				})
			end
		end

		vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
			virt_text = { { prompt_str, "PickPrompt" }, { " ", "Normal" } },
			virt_text_pos = "inline",
			right_gravity = false,
		})
		vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
			virt_text = { { ("(%d/%d)"):format(#matches, #norm), "Comment" } },
			virt_text_pos = "right_align",
			hl_mode = "combine",
		})

		pcall(vim.api.nvim_win_set_cursor, win, { 1, #input })
		vim.api.nvim_win_call(win, function()
			vim.fn.winrestview({ topline = 1 })
		end)
	end

	local function filter()
		if closed then
			return
		end
		local new_input = vim.api.nvim_get_current_line()
		if new_input == last_rendered_input then
			return
		end
		input = new_input

		if #input == 0 then
			matches = all_matches()
		else
			local r = vim.fn.matchfuzzypos(norm, input, { key = "text" })
			matches = {}
			for i = 1, #r[1] do
				matches[i] = { r[1][i].id, r[2][i], r[3][i] }
			end
		end

		idx = #matches > 0 and 1 or 0
		offset = 0
		vim.schedule(render)
	end

	local function try_resume(action)
		if co and coroutine.status(co) == "suspended" then
			coroutine.resume(co, action)
		end
	end

	local function set_keymaps()
		local o = { buffer = buf, nowait = true }
		vim.keymap.set("i", "<CR>", function()
			try_resume(ACCEPT)
		end, o)
		vim.keymap.set("i", "<C-y>", function()
			try_resume(ACCEPT)
		end, o)
		vim.keymap.set("i", "<Esc>", function()
			try_resume(CANCEL)
		end, o)
		vim.keymap.set("i", "<Down>", function()
			idx = idx + 1
			render()
		end, o)
		vim.keymap.set("i", "<Up>", function()
			idx = idx - 1
			render()
		end, o)
		vim.keymap.set("i", "<C-n>", function()
			idx = idx + 1
			render()
		end, o)
		vim.keymap.set("i", "<C-p>", function()
			idx = idx - 1
			render()
		end, o)
		vim.keymap.set("i", "<C-s>", function()
			try_resume(SPLIT)
		end, o)
		vim.keymap.set("i", "<C-v>", function()
			try_resume(VSPLIT)
		end, o)
	end

	picker_count = picker_count + 1
	local my_id = picker_count

	coroutine.wrap(function()
		saved_view = vim.fn.winsaveview()
		saved_win = vim.api.nvim_get_current_win()

		set_keymaps()
		render()

		vim._with({ noautocmd = true }, function()
			vim.api.nvim_set_current_win(win)
		end)
		vim._with({ noautocmd = true }, function()
			vim.cmd.startinsert({ bang = true })
		end)

		augroup = vim.api.nvim_create_augroup("tt_pick_" .. my_id, {})
		vim.api.nvim_create_autocmd("ModeChanged", {
			group = augroup,
			callback = function(ev)
				if ev.match:match("^i:") then
					try_resume(CANCEL)
				end
			end,
		})
		vim.api.nvim_create_autocmd("TextChangedI", {
			group = augroup,
			buffer = buf,
			callback = filter,
		})
		vim.api.nvim_create_autocmd("VimResized", {
			group = augroup,
			callback = render,
		})

		co = coroutine.running()
		active_co = co
		local result = coroutine.yield()

		closed = true

		vim.schedule(function()
			pcall(vim.api.nvim_del_augroup_by_id, augroup)

			if active_co == co or active_co == nil then
				active_co = nil
				vim.cmd.stopinsert()
				if vim.api.nvim_win_is_valid(win) then
					vim.api.nvim_win_close(win, true)
				end
				pcall(vim.api.nvim_set_current_win, saved_win)
				pcall(vim.fn.winrestview, saved_view)
			end

			vim.defer_fn(function()
				if result ~= CANCEL then
					local m = matches[idx]
					if m then
						local item = norm[m[1]]
						if item then
							on_choice(item.value, item.id, action_name[result] or "edit")
						end
					end
				elseif on_cancel then
					on_cancel()
				end
			end, 10)
		end)
	end)()
end

function M.select(items, opts, on_choice)
	opts = opts or {}
	M.open(items, {
		prompt = opts.prompt,
		format_item = opts.format_item,
		on_choice = function(item, item_idx)
			on_choice(item, item_idx)
		end,
		on_cancel = function()
			on_choice(nil, nil)
		end,
	})
end

return M
