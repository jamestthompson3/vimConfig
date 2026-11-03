local M = {}

local ns = vim.api.nvim_create_namespace("tt_pick")

local ACCEPT, CANCEL, SPLIT, VSPLIT = 0, 1, 2, 3
local action_name = { [ACCEPT] = "edit", [SPLIT] = "split", [VSPLIT] = "vsplit" }

local active_task = nil
local active_origin = nil
local noautocmd = require("tt.compat").noautocmd
local picker_count = 0

local function setup_highlights()
	local hi = function(name, val)
		val.default = true
		vim.api.nvim_set_hl(0, name, val)
	end
	hi("PickNormal", { link = "NormalFloat" })
	hi("PickBorder", { link = "FloatBorder" })
	hi("PickSel", { link = "PmenuSel" })
	hi("PickPointer", { link = "WildMenu" })
	hi("PickMatch", { link = "PmenuMatch" })
end

local function normalize_items(items, opts)
	local normalized = {}
	for i, item in ipairs(items) do
		local text = opts.format_item and opts.format_item(item) or type(item) == "string" and item or tostring(item)
		normalized[i] = { id = i, text = text, value = item }
	end
	return normalized
end

function M.open(items, opts)
	opts = opts or {}

	local origin = active_origin or { win = vim.api.nvim_get_current_win(), view = vim.fn.winsaveview() }
	if active_task and not active_task:completed() then
		active_task:close()
	end
	active_origin = origin

	setup_highlights()

	local title = opts.prompt and (" " .. opts.prompt .. " ") or ""
	local on_choice = opts.on_choice or function() end
	local on_cancel = opts.on_cancel

	local norm = normalize_items(items, opts)

	local input, filtered_input = "", ""
	local matches = {}
	local pos_cache = {}
	local idx = 0
	local offset = 0
	local closed = false
	local augroup, saved_view, saved_win
	local resolve, filter_task
	local debounce = opts.debounce or 50
	local result_limit = opts.limit or 200

	local win_width = math.max(1, math.min(vim.o.columns - 2, math.floor(vim.o.columns * 0.7)))
	local win_col = math.floor((vim.o.columns - win_width) / 2)
	local function max_h()
		return math.max(1, math.min(#items + 1, vim.o.lines - 2, math.ceil(vim.o.lines * (opts.height or 0.4))))
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
		title = title,
		title_pos = "center",
	})
	vim.wo[win].wrap = false
	vim.wo[win].cursorline = false
	vim.api.nvim_set_option_value(
		"winhighlight",
		"Normal:PickNormal,FloatBorder:PickBorder",
		{ scope = "local", win = win }
	)

	matches = norm
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

	-- matchfuzzypos returns copies. Cache positions by item ID.
	local function match_positions(visible)
		local positions = {}
		if #input > 0 then
			local missing = {}
			for _, item in ipairs(visible) do
				if pos_cache[item.id] == nil then
					missing[#missing + 1] = item
				end
			end
			if #missing > 0 then
				local result = vim.fn.matchfuzzypos(missing, input, { key = "text" })
				for i, item in ipairs(result[1]) do
					pos_cache[item.id] = result[2][i]
				end
			end
			for i, item in ipairs(visible) do
				positions[i] = pos_cache[item.id] or {}
			end
		end
		return positions
	end

	local function render()
		if closed or not vim.api.nvim_win_is_valid(win) then
			return
		end
		win_width = math.max(1, math.min(vim.o.columns - 2, math.floor(vim.o.columns * 0.7)))
		win_col = math.max(0, math.floor((vim.o.columns - win_width) / 2))
		initial_h = max_h()

		local pointer = " "
		local indent_n = #pointer + 1
		local prefix = (" "):rep(indent_n)
		local lm = list_max()

		update_offset()

		local lines = { input }
		local vis = {}
		for i = 1 + offset, math.min(#matches, lm + offset) do
			lines[#lines + 1] = prefix .. matches[i].text
			vis[#vis + 1] = matches[i]
		end
		local match_count = #lines - 1

		local all_pos = match_positions(vis)

		noautocmd(function()
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
				local first = vim.fn.byteidx(vis[i].text, c)
				local last = vim.fn.byteidx(vis[i].text, c + 1)
				pcall(vim.api.nvim_buf_set_extmark, buf, ns, i, indent_n + first, {
					end_col = indent_n + (last == -1 and #vis[i].text or last),
					hl_group = "PickMatch",
					hl_mode = "combine",
				})
			end
		end

		if idx > 0 then
			-- update_offset keeps the selected row within the visible rows.
			local row = idx - offset
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

		vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
			virt_text = { { " ", "Normal" } },
			virt_text_pos = "inline",
			right_gravity = false,
		})
		-- A limited search does not give the total match count.
		local shown = (#input > 0 and #matches >= result_limit) and (result_limit .. "+") or tostring(#matches)
		vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, {
			virt_text = { { ("(%s/%d)"):format(shown, #norm), "Comment" } },
			virt_text_pos = "right_align",
			hl_mode = "combine",
		})

		pcall(vim.api.nvim_win_set_cursor, win, { 1, #input })
		vim.api.nvim_win_call(win, function()
			vim.fn.winrestview({ topline = 1 })
		end)
	end

	local function recompute()
		if closed then
			return
		end
		filtered_input = input
		pos_cache = {}
		if #input == 0 then
			matches = norm
		else
			matches = vim.fn.matchfuzzy(norm, input, { key = "text", limit = result_limit })
		end

		idx = #matches > 0 and 1 or 0
		offset = 0
		render()
	end

	local function filter()
		if closed then
			return
		end
		local new_input = vim.api.nvim_get_current_line()
		if new_input == input then
			return
		end
		input = new_input
		-- Closing the previous task cancels its delay.
		if filter_task and not filter_task:completed() then
			filter_task:close()
		end
		filter_task = vim.async.run(function()
			vim.async.sleep(debounce)
			recompute()
		end)
	end

	local function flush_filter()
		if filter_task and not filter_task:completed() then
			filter_task:close()
		end
		input = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
		if input ~= filtered_input then
			recompute()
		end
	end

	local function try_resume(action)
		if action ~= CANCEL then
			flush_filter()
		end
		if resolve then
			local done = resolve
			resolve = nil
			done(action)
		end
	end

	local function set_keymaps()
		local o = { buf = buf, nowait = true }
		vim.keymap.set("i", "<CR>", function()
			try_resume(ACCEPT)
		end, o)
		vim.keymap.set("i", "<C-y>", function()
			try_resume(ACCEPT)
		end, o)
		vim.keymap.set("i", "<Esc>", function()
			try_resume(CANCEL)
		end, o)
		local function move(delta)
			flush_filter()
			idx = idx + delta
			render()
		end
		vim.keymap.set("i", { "<Down>", "<C-n>" }, function()
			move(1)
		end, o)
		vim.keymap.set("i", { "<Up>", "<C-p>" }, function()
			move(-1)
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

	local task = vim.async.run(function()
		saved_view, saved_win = origin.view, origin.win

		set_keymaps()
		render()

		noautocmd(function()
			vim.api.nvim_set_current_win(win)
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
			buf = buf,
			callback = filter,
		})
		vim.api.nvim_create_autocmd("VimResized", {
			group = augroup,
			callback = render,
		})
		vim.api.nvim_create_autocmd("BufWipeout", {
			group = augroup,
			buf = buf,
			callback = function()
				try_resume(CANCEL)
			end,
		})

		return vim.async.await(function(done)
			resolve = done
		end)
	end)
	active_task = task

	task:on_complete(function(err, result)
		closed = true
		resolve = nil
		-- Task:close() completes with an error, not a picker action.
		if err then
			result = CANCEL
		end

		vim.schedule(function()
			pcall(vim.api.nvim_del_augroup_by_id, augroup)
			if filter_task and not filter_task:completed() then
				pcall(function()
					filter_task:close()
				end)
			end

			local restore = active_task == task
			if restore then
				active_task, active_origin = nil, nil
				vim.cmd.stopinsert()
			end
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			if restore then
				pcall(vim.api.nvim_set_current_win, saved_win)
				pcall(vim.fn.winrestview, saved_view)
			end

			vim.defer_fn(function()
				if result ~= CANCEL then
					local m = matches[idx]
					local item = m and norm[m.id]
					if item then
						on_choice(item.value, item.id, action_name[result] or "edit")
					end
				elseif on_cancel then
					on_cancel()
				end
			end, 10)
		end)
	end)
end

function M.numbered(items, opts)
	opts = opts or {}
	setup_highlights()

	local on_choice = opts.on_choice or function() end
	local on_delete = opts.on_delete
	local on_cancel = opts.on_cancel
	local title = opts.prompt and (" " .. opts.prompt .. " ") or ""

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"

	local saved_win = vim.api.nvim_get_current_win()
	local win
	local closed = false
	local chosen = false
	local sized = false

	local function label(i)
		if i <= 9 then
			return tostring(i)
		elseif i == 10 then
			return "0"
		end
		return nil
	end

	local function render()
		if closed then
			return
		end
		local lines = {}
		local width = vim.fn.strdisplaywidth(title)
		local name_w = 0
		for _, item in ipairs(items) do
			if item.hint then
				name_w = math.max(name_w, vim.fn.strdisplaywidth(item.text))
			end
		end
		local hint_cols = {}
		for i, item in ipairs(items) do
			local key = label(i)
			local prefix = key and (" " .. key .. "  ") or "    "
			local line = prefix .. item.text
			if item.hint then
				local pad = name_w - vim.fn.strdisplaywidth(item.text) + 2
				line = line .. (" "):rep(pad)
				hint_cols[i] = { start = #line }
				line = line .. item.hint
				hint_cols[i].stop = #line
			end
			lines[i] = line
			width = math.max(width, vim.fn.strdisplaywidth(lines[i]))
		end
		if #lines == 0 then
			lines = { "  (empty)" }
		end

		vim.bo[buf].modifiable = true
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.bo[buf].modifiable = false

		-- Keep the window size fixed so item removal does not move the cursor.
		if not sized and win and vim.api.nvim_win_is_valid(win) then
			sized = true
			local max_w = math.floor(vim.o.columns * 0.7)
			width = math.max(20, math.min(width + 2, max_w))
			local height = math.max(1, math.min(#items, math.floor(vim.o.lines * (opts.height or 0.4))))
			pcall(vim.api.nvim_win_set_config, win, {
				relative = "editor",
				width = width,
				height = height,
				row = math.floor((vim.o.lines - height) / 2),
				col = math.floor((vim.o.columns - width) / 2),
			})
		end

		vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
		for i = 1, #items do
			if label(i) then
				pcall(vim.api.nvim_buf_set_extmark, buf, ns, i - 1, 1, {
					end_col = 2,
					hl_group = "PickPointer",
					hl_mode = "combine",
				})
			end
			if hint_cols[i] then
				pcall(vim.api.nvim_buf_set_extmark, buf, ns, i - 1, hint_cols[i].start, {
					end_col = hint_cols[i].stop,
					hl_group = "Comment",
					hl_mode = "combine",
				})
			end
		end
	end

	local function close()
		if closed then
			return
		end
		closed = true
		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		pcall(vim.api.nvim_set_current_win, saved_win)
		if not chosen and on_cancel then
			on_cancel()
		end
	end

	local function choose(i, action)
		local item = items[i]
		if not item then
			return
		end
		chosen = true
		close()
		on_choice(item.value, action or "edit")
	end

	win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = 20,
		height = 1,
		row = 0,
		col = 0,
		style = "minimal",
		border = "rounded",
		title = title,
		title_pos = "center",
	})
	vim.wo[win].wrap = false
	vim.wo[win].cursorline = true
	vim.api.nvim_set_option_value(
		"winhighlight",
		"Normal:PickNormal,FloatBorder:PickBorder,CursorLine:PickSel",
		{ scope = "local", win = win }
	)
	render()

	local o = { buf = buf, nowait = true, silent = true }
	for i = 1, 10 do
		vim.keymap.set("n", label(i), function()
			choose(i)
		end, o)
	end
	local function cursor_row()
		return vim.api.nvim_win_get_cursor(win)[1]
	end
	vim.keymap.set("n", "<CR>", function()
		choose(cursor_row())
	end, o)
	vim.keymap.set("n", "<C-s>", function()
		choose(cursor_row(), "split")
	end, o)
	vim.keymap.set("n", "<C-v>", function()
		choose(cursor_row(), "vsplit")
	end, o)
	vim.keymap.set("n", "dd", function()
		local i = cursor_row()
		if not items[i] then
			return
		end
		if on_delete then
			on_delete(items[i].value, i)
		end
		table.remove(items, i)
		if #items == 0 then
			close()
			return
		end
		render()
		pcall(vim.api.nvim_win_set_cursor, win, { math.min(i, #items), 0 })
	end, o)
	vim.keymap.set("n", "q", close, o)
	vim.keymap.set("n", "<Esc>", close, o)

	vim.api.nvim_create_autocmd("WinLeave", { buf = buf, once = true, callback = close })
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
