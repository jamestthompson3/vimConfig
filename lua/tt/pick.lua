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

	local title = opts.prompt and (" " .. opts.prompt .. " ") or ""
	local on_choice = opts.on_choice or function() end
	local on_cancel = opts.on_cancel

	local norm = {}
	for i, item in ipairs(items) do
		local text = opts.format_item and opts.format_item(item) or type(item) == "string" and item or tostring(item)
		norm[i] = { id = i, text = text, value = item }
	end

	local input = ""
	local matches = {}
	local pos_cache = {}
	local idx = 0
	local offset = 0
	local closed = false
	local co, augroup, saved_view, saved_win
	local filter_timer = (vim.uv or vim.loop).new_timer()
	local debounce = opts.debounce or 50
	local result_limit = opts.limit or 200

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

	local function render()
		if closed then
			return
		end

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

		-- Compute highlight positions only for the visible rows, keyed back to
		-- each item by id (Vim's fuzzy fns return copies, so table identity
		-- can't be used) and cached across renders (reset on requery).
		-- Navigating within an already-seen window costs no extra fuzzy calls;
		-- scrolling only pays for the newly revealed rows.
		local all_pos = {}
		if #input > 0 then
			local missing = {}
			for _, item in ipairs(vis) do
				if pos_cache[item.id] == nil then
					missing[#missing + 1] = item
				end
			end
			if #missing > 0 then
				local r = vim.fn.matchfuzzypos(missing, input, { key = "text" })
				for i, item in ipairs(r[1]) do
					pos_cache[item.id] = r[2][i]
				end
			end
			for i = 1, #vis do
				all_pos[i] = pos_cache[vis[i].id] or {}
			end
		end

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
			virt_text = { { " ", "Normal" } },
			virt_text_pos = "inline",
			right_gravity = false,
		})
		-- When a query hits the result cap we can't know the true match total,
		-- so show it as "N+" rather than a misleading exact figure.
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
		pos_cache = {}
		if #input == 0 then
			matches = norm
		else
			-- Cap to the top-ranked matches: sorting the full match set of a
			-- broad query (tens of thousands of items) dominates the cost, and
			-- nobody scrolls a 65k list -- you refine the query instead. Also
			-- use matchfuzzy over matchfuzzypos so we don't build a discarded
			-- position array per match; positions for the few visible rows are
			-- computed lazily in render().
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
		-- Debounce: coalesce bursts of keystrokes so the (on large lists,
		-- expensive) fuzzy match runs once typing settles rather than per key.
		filter_timer:stop()
		filter_timer:start(debounce, 0, vim.schedule_wrap(recompute))
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
			pcall(function()
				filter_timer:stop()
				filter_timer:close()
			end)

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
					-- matches may hold copies (fuzzy fns copy dict items), so map
					-- back to the original item by id to hand out the real value.
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
	end)()
end

-- A normal-mode, numbered list picker. Unlike M.open (fuzzy, insert-mode),
-- this shows a fixed list where 1-9 and 0 jump directly to an item, <CR>
-- opens the item under the cursor, and `dd` removes an item from the list.
--   items: { { text = <string>, value = <any> }, ... }
--   opts.on_choice(value, action)  -- action is "edit" | "split" | "vsplit"
--   opts.on_delete(value, idx)     -- called before the item is removed
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
		-- When items carry a `hint` (e.g. a containing dir), left-align the
		-- primary text into a column so the eye scans one edge, then trail the
		-- hint dimmed. `hint_cols` records byte ranges for the Comment extmarks.
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

		-- Size the window once, from the initial list, and keep it fixed so
		-- deleting an item (dd) doesn't shrink the float underneath the cursor.
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

	local o = { buffer = buf, nowait = true, silent = true }
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

	vim.api.nvim_create_autocmd("WinLeave", { buffer = buf, once = true, callback = close })
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
