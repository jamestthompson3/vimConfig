local M = { input_marker = "Input>", separator = "----------------" }
local TOOL_STATUS = { pending = "[wait]", in_progress = "[run]", completed = "[ok]", failed = "[fail]" }
local PLAN_MARK = { pending = "[ ]", in_progress = "[~]", completed = "[x]" }
local ROLE_HIGHLIGHT = { You = "AcpUser", Pi = "AcpAssistant" }
local STATE_HIGHLIGHT =
	{ pending = "AcpPending", in_progress = "AcpRunning", completed = "AcpSuccess", failed = "AcpFailure" }
local window_options = {
	wrap = true,
	linebreak = true,
	breakindent = true,
	number = false,
	relativenumber = false,
	signcolumn = "no",
	foldcolumn = "0",
	foldmethod = "manual",
	foldenable = false,
	conceallevel = 0,
	spell = false,
	list = false,
}

function M.setup_window(win)
	win = win or 0
	for name, value in pairs(window_options) do
		vim.api.nvim_set_option_value(name, value, { win = win })
	end
end

local function entry_renderers(push, push_text, messages, highlight)
	local function heading(role, entry)
		messages[#messages + 1] = { row = push(role .. ":", ROLE_HIGHLIGHT[role]), role = role, entry = entry }
		push("")
	end
	return {
		user = function(entry)
			heading("You", entry)
			for _, label in ipairs(entry.refs or {}) do
				push_text("[file] " .. label, "AcpAttachment")
			end
			if entry.refs and #entry.refs > 0 then
				push("")
			end
			push_text(entry.text)
			push("")
		end,
		assistant = function(entry)
			heading("Pi", entry)
			push_text(entry.text)
			push("")
		end,
		status = function(entry)
			push_text(entry.text, entry.text == "[error]" and "AcpFailure" or "AcpNotice")
			push("")
		end,
		thought = function(entry)
			push("[thinking]", "AcpMuted")
			for _, line in ipairs(vim.split(entry.text, "\n", { plain = true })) do
				push("  " .. line, "AcpMuted")
			end
			push("")
		end,
		tool = function(entry)
			local status = TOOL_STATUS[entry.status] or "[wait]"
			local kind = entry.tool_kind and (" (" .. entry.tool_kind .. ")") or ""
			local row = push_text(string.format("%s %s%s", status, entry.title or "tool", kind))
			highlight(row, STATE_HIGHLIGHT[entry.status] or "AcpPending", 0, #status)
			push("")
		end,
		plan = function(entry)
			push("Plan:", "AcpHeading")
			for _, item in ipairs(entry.entries or {}) do
				local row = push_text(string.format("  %s %s", PLAN_MARK[item.status] or "[ ]", item.content or ""))
				highlight(row, STATE_HIGHLIGHT[item.status] or "AcpPending", 2, 5)
			end
			push("")
		end,
	}
end

local function turn_end(entries, first)
	local turn = entries[first].turn
	local next_turn = first + 1
	while next_turn <= #entries and entries[next_turn].turn == turn do
		next_turn = next_turn + 1
	end
	return next_turn
end

local function render_live_turn(entries, first, stop, verbose, renderers, summary)
	local index = first
	while index < stop do
		local entry = entries[index]
		if entry.kind ~= "tool" or verbose then
			local draw = renderers[entry.kind]
			if draw then
				draw(entry)
			end
			index = index + 1
		else
			local count, failed = 0, 0
			while index < stop and entries[index].kind == "tool" do
				count = count + 1
				if entries[index].status == "failed" then
					failed = failed + 1
				end
				index = index + 1
			end
			summary(count, failed)
		end
	end
end

local function render_completed_turn(entries, first, stop, renderers, summary)
	local count, failed, final_assistant, final_status = 0, 0, nil, nil
	for index = first, stop - 1 do
		local entry = entries[index]
		if entry.kind == "user" then
			renderers.user(entry)
		elseif entry.kind == "tool" then
			count = count + 1
			if entry.status == "failed" then
				failed = failed + 1
			end
		elseif entry.kind == "assistant" then
			final_assistant = entry
		elseif entry.kind == "status" then
			final_status = entry
		end
	end
	if count > 0 then
		summary(count, failed)
	end
	if final_assistant then
		renderers.assistant(final_assistant)
	end
	if final_status then
		renderers.status(final_status)
	end
end

local function render_input(chat, push, push_text, separator, wrote)
	if chat.status == "busy" then
		push("[working] Ctrl-C to cancel", "AcpRunning")
		return
	end
	if wrote then
		separator()
	end
	local refs = chat.pending_refs or {}
	if #refs > 0 then
		push("Attached:", "AcpHeading")
		for _, ref in ipairs(refs) do
			push_text("[file] " .. ref.label, "AcpAttachment")
		end
		push("")
	end
	local row = push(M.input_marker, "AcpInput")
	push("")
	push("")
	return row
end

function M.lines(chat)
	local lines, messages, highlights = {}, {}, {}
	local function highlight(row, group, first, last)
		highlights[#highlights + 1] = { row = row, group = group, first = first, last = last }
	end
	local function push(line, group)
		lines[#lines + 1] = line
		if group and #line > 0 then
			highlight(#lines, group, 0, #line)
		end
		return #lines
	end
	local function push_text(text, group)
		local first = #lines + 1
		for _, line in ipairs(vim.split(text, "\n", { plain = true })) do
			push(line, group)
		end
		return first
	end
	local function summary(count, failed)
		local note = failed > 0 and string.format(", %d failed", failed) or ""
		local text = string.format("[tools] %d call%s%s", count, count == 1 and "" or "s", note)
		local row = push(text, "AcpMuted")
		if failed > 0 then
			highlight(row, "AcpFailure", #text - #note + 2, #text)
		end
		push("")
	end
	local function separator()
		push(M.separator, "AcpSeparator")
		push("")
	end
	local renderers = entry_renderers(push, push_text, messages, highlight)
	local entries, first, wrote = chat.entries, 1, false
	while first <= #entries do
		local stop = turn_end(entries, first)
		if wrote then
			separator()
		end
		local turn = entries[first].turn
		local complete = chat.status ~= "busy" or (turn ~= nil and turn < chat.turn)
		if chat.verbose or not complete then
			render_live_turn(entries, first, stop, chat.verbose, renderers, summary)
		else
			render_completed_turn(entries, first, stop, renderers, summary)
		end
		first, wrote = stop, true
	end
	local input_row = render_input(chat, push, push_text, separator, wrote)
	return lines, { messages = messages, input_row = input_row, highlights = highlights }
end

function M.transcript(chat)
	local out = {}
	for _, entry in ipairs(chat.entries) do
		if entry.kind == "user" then
			out[#out + 1] = "You:\n\n" .. entry.text
		elseif entry.kind == "assistant" then
			out[#out + 1] = "Pi:\n\n" .. entry.text
		end
	end
	return table.concat(out, "\n\n")
end

return M
