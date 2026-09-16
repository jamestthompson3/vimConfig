-- acp.lua - drive Claude Code from inside neovim over the Agent Client Protocol.
--
-- Neovim is the ACP *client*. We spawn the @zed-industries/claude-code-acp
-- bridge as a long-lived subprocess and speak newline-delimited JSON-RPC 2.0 to
-- it over stdio. The bridge wraps the Claude Code CLI and authenticates from the
-- local `claude` login (keychain) -- i.e. your Pro/Max subscription, no API key.
--
-- One bridge process serves many sessions; one session backs each chat buffer.
--
--   Phase 1  transport + `:AgentPing`
--   Phase 2  chat buffer: `:Agent`, model-driven renderer, send/cancel  <-- here
--
-- Protocol shapes are pinned against the real bridge (v0.16.2, protocol 1):
--   initialize     -> { protocolVersion, agentCapabilities, authMethods, ... }
--   session/new    -> { sessionId, models, modes }
--   session/prompt -> streams session/update notifications, ends { stopReason }
--   session/cancel -> notification { sessionId }
--   session/update -> { sessionId, update = { sessionUpdate = "...", ... } }
--     agent_message_chunk       update.content = { type="text", text }
--     agent_thought_chunk       update.content = { type="text", text }
--     tool_call                 { toolCallId, title, kind, status }
--     tool_call_update          { toolCallId, status?, title? }
--     plan                      { entries = { { content, priority, status } } }
--     available_commands_update { availableCommands = { { name, description } } }

local M = {}

-- When true, the bridge's stderr is echoed live via vim.notify. Off by default
-- (the bridge is chatty); recent stderr is always kept for |:AgentLog|.
M.debug = false

-- The ACP bridge. `sh -c` wrapper guarantees CLAUDECODE / CLAUDE_CODE_ENTRYPOINT
-- are unset (the bridge refuses to launch nested inside a Claude Code session);
-- harmless when they were never set.
local BRIDGE_CMD = {
	"sh",
	"-c",
	"unset CLAUDECODE CLAUDE_CODE_ENTRYPOINT; exec npx -y @zed-industries/claude-code-acp",
}
local PROTOCOL_VERSION = 1

---@class AcpClient
---@field job integer
---@field stdout string
---@field next_id integer
---@field pending table<integer, fun(result: any|nil, err: any|nil)>
---@field initialized boolean
---@field init_caps table|nil
---@field sessions table<string, { on_update: fun(update: table) }>

---@type AcpClient|nil
local client = nil

--------------------------------------------------------------------- transport

local function write(msg)
	if client then
		vim.fn.chansend(client.job, vim.json.encode(msg) .. "\n")
	end
end

--- Fire a request; invoke `cb(result, err)` when its response arrives.
local function request(method, params, cb)
	if not client then
		return
	end
	local id = client.next_id
	client.next_id = id + 1
	if cb then
		client.pending[id] = cb
	end
	write({ jsonrpc = "2.0", id = id, method = method, params = params or vim.empty_dict() })
end

--- Fire a notification (no response expected).
local function notify(method, params)
	write({ jsonrpc = "2.0", method = method, params = params or vim.empty_dict() })
end

--- Reply to a request the *agent* made of us.
local function respond(id, result)
	write({ jsonrpc = "2.0", id = id, result = result })
end

local function respond_error(id, code, message)
	write({ jsonrpc = "2.0", id = id, error = { code = code, message = message } })
end

-- Filled in by the chat layer so fs/permission handlers can find the owning
-- chat (for live-buffer reads and the accept-edits toggle).
local chat_by_session = function(_) end
local loaded_buf = function(_) end

--- fs/read_text_file: serve from the live buffer if one is loaded (so the agent
--- sees unsaved edits), else from disk. Honours the line/limit window.
local function handle_fs_read(msg)
	local p = msg.params or {}
	local lines
	local buf = loaded_buf(p.path)
	if buf then
		lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	else
		local ok, disk = pcall(vim.fn.readfile, p.path)
		if not ok then
			respond_error(msg.id, -32603, "cannot read " .. tostring(p.path))
			return
		end
		lines = disk
	end
	local first = p.line and math.max(p.line, 1) or 1
	local last = p.limit and (first + p.limit - 1) or #lines
	local slice = {}
	for i = first, math.min(last, #lines) do
		slice[#slice + 1] = lines[i]
	end
	respond(msg.id, { content = table.concat(slice, "\n") })
end

--- fs/write_text_file: apply the write to a loaded buffer (visible + undoable)
--- and persist it, so edits show up in nvim exactly as on disk.
local function handle_fs_write(msg)
	local p = msg.params or {}
	local ok, err = pcall(function()
		local buf = vim.fn.bufadd(p.path)
		vim.fn.bufload(buf)
		vim.bo[buf].modifiable = true
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(p.content or "", "\n", { plain = true }))
		-- noautocmd so format-on-save et al don't fight the agent's write.
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("silent noautocmd keepalt write!")
		end)
	end)
	if ok then
		respond(msg.id, vim.NIL)
	else
		respond_error(msg.id, -32603, "cannot write " .. tostring(p.path) .. ": " .. tostring(err))
	end
end

local function pick_option(options, want)
	for _, o in ipairs(options or {}) do
		if o.kind == want or o.optionId == want then
			return o
		end
	end
	return (options or {})[1]
end

--- session/request_permission: auto-approve when the chat is in accept-edits
--- mode, otherwise ask via vim.ui.select. Responds asynchronously (allowed).
local function handle_permission(msg)
	local p = msg.params or {}
	local chat = chat_by_session(p.sessionId)
	if chat and chat.accept_edits then
		local allow = pick_option(p.options, "allow_once")
		respond(msg.id, { outcome = { outcome = "selected", optionId = allow and allow.optionId } })
		return
	end
	vim.schedule(function()
		-- Floating numbered picker (matches the buffer picker): the window title
		-- is the requested action; options are numbered 1-3 (Always Allow /
		-- Allow / Reject). Dismissing (Esc/q) answers as cancelled.
		local title = (p.toolCall and p.toolCall.title) or "permission request"
		local items = {}
		for _, o in ipairs(p.options or {}) do
			items[#items + 1] = { text = o.name or o.optionId, value = o }
		end
		require("tt.pick").numbered(items, {
			prompt = title,
			on_choice = function(opt)
				respond(msg.id, { outcome = { outcome = "selected", optionId = opt.optionId } })
				if opt.kind == "allow_always" and chat then
					chat.accept_edits = true
					vim.notify("acp: accept-edits enabled for this chat")
				end
			end,
			on_cancel = function()
				respond(msg.id, { outcome = { outcome = "cancelled" } })
			end,
		})
	end)
end

local function handle_agent_request(msg)
	local method = msg.method
	if method == "fs/read_text_file" then
		handle_fs_read(msg)
	elseif method == "fs/write_text_file" then
		handle_fs_write(msg)
	elseif method == "session/request_permission" then
		handle_permission(msg)
	else
		respond(msg.id, vim.NIL)
	end
end

local function dispatch(msg)
	if msg.method and msg.id ~= nil then
		handle_agent_request(msg)
	elseif msg.method then
		if msg.method == "session/update" and msg.params then
			local sess = client and client.sessions[msg.params.sessionId]
			if sess and sess.on_update then
				sess.on_update(msg.params.update)
			end
		end
	elseif msg.id ~= nil then
		local cb = client and client.pending[msg.id]
		if cb then
			client.pending[msg.id] = nil
			cb(msg.result, msg.error)
		end
	end
end

local function on_stdout(_, data)
	if not client then
		return
	end
	client.stdout = client.stdout .. table.concat(data, "\n")
	while true do
		local nl = client.stdout:find("\n", 1, true)
		if not nl then
			break
		end
		local line = client.stdout:sub(1, nl - 1)
		client.stdout = client.stdout:sub(nl + 1)
		if line ~= "" then
			local ok, msg = pcall(vim.json.decode, line)
			if ok then
				dispatch(msg)
			end
		end
	end
end

local function ensure_spawned()
	if client and client.job > 0 then
		return client
	end
	if vim.env.ANTHROPIC_API_KEY and vim.env.ANTHROPIC_API_KEY ~= "" then
		vim.notify("acp: ANTHROPIC_API_KEY is set -- Claude Code will bill the API, not your subscription", vim.log.levels.WARN)
	end

	client = { job = 0, stdout = "", next_id = 1, pending = {}, initialized = false, init_caps = nil, sessions = {}, stderr_log = {} }
	local job = vim.fn.jobstart(BRIDGE_CMD, {
		on_stdout = on_stdout,
		on_stderr = function(_, data)
			-- Keep a bounded ring of stderr for :AgentLog; only surface it to
			-- :messages when M.debug is on, so the bridge doesn't spam you.
			if not client then
				return
			end
			local log = client.stderr_log
			for _, line in ipairs(data) do
				if line ~= "" then
					log[#log + 1] = line
					if #log > 200 then
						table.remove(log, 1)
					end
					if M.debug then
						vim.schedule(function()
							vim.notify("acp bridge: " .. line, vim.log.levels.DEBUG)
						end)
					end
				end
			end
		end,
		on_exit = function()
			client = nil
		end,
	})
	if job <= 0 then
		vim.notify("acp: failed to launch bridge", vim.log.levels.ERROR)
		client = nil
		return nil
	end
	client.job = job
	return client
end

local function ensure_initialized(cb)
	local c = ensure_spawned()
	if not c then
		return
	end
	if c.initialized then
		cb()
		return
	end
	request("initialize", {
		protocolVersion = PROTOCOL_VERSION,
		clientCapabilities = { fs = { readTextFile = true, writeTextFile = true }, terminal = false },
	}, function(result, err)
		if err then
			vim.schedule(function()
				vim.notify("acp initialize failed: " .. vim.inspect(err), vim.log.levels.ERROR)
			end)
			return
		end
		c.initialized = true
		c.init_caps = result and result.agentCapabilities
		cb()
	end)
end

local function new_session(cwd, on_update, cb)
	ensure_initialized(function()
		request("session/new", { cwd = cwd, mcpServers = {} }, function(result, err)
			if err or not (result and result.sessionId) then
				vim.schedule(function()
					vim.notify("acp session/new failed: " .. vim.inspect(err or result), vim.log.levels.ERROR)
				end)
				cb(nil, nil)
				return
			end
			if client then
				client.sessions[result.sessionId] = { on_update = on_update }
			end
			cb(result.sessionId, result)
		end)
	end)
end

--- Resume a persisted session (`session/load`). The agent replays the whole
--- history as session/update notifications *before* the load response; we
--- register the update handler only after load resolves, so that replay is
--- dropped (we already restored the transcript from disk) and only new activity
--- renders. Requires the original `cwd`.
local function load_session(sessionId, cwd, on_update, cb)
	ensure_initialized(function()
		request("session/load", { sessionId = sessionId, cwd = cwd, mcpServers = {} }, function(result, err)
			if err then
				vim.schedule(function()
					vim.notify("acp session/load failed: " .. vim.inspect(err), vim.log.levels.ERROR)
				end)
				cb(nil, nil)
				return
			end
			if client then
				client.sessions[sessionId] = { on_update = on_update }
			end
			cb(sessionId, result)
		end)
	end)
end

--- Send prompt content blocks to a session. `cb(stopReason)` fires at turn end.
local function send_prompt(sessionId, blocks, cb)
	request("session/prompt", { sessionId = sessionId, prompt = blocks }, function(result, err)
		if cb then
			cb(err and nil or (result and result.stopReason))
		end
	end)
end

local function cancel(sessionId)
	notify("session/cancel", { sessionId = sessionId })
end

-------------------------------------------------------------------- chat model

-- chats[buf] = {
--   buf, root, id, sessionId, status = "idle"|"busy",
--   entries = { {kind, ...}, ... }, tool_index = { [toolCallId] = entry },
--   plan = { entries = {...} } | nil, commands = {...}, redraw_scheduled = bool,
-- }
local chats = {}
local chat_counter = 0
local last_chat_buf = nil -- most-recently-used chat, for context attach / save
-- Last-seen slash commands (from available_commands_update). Cached module-wide
-- so a new chat can complete `/commands` before its own first turn arrives.
local command_cache = {}

local USER_HEADER = "## You"
-- The trailing input prompt. Deliberately NOT a `#` heading, so markdown header
-- motions ([[ / ]] / gO) skip it and `[[` from the input lands directly on the
-- last `## Claude` (the reply). read_input() anchors on this exact line.
local INPUT_MARKER = "❯ You"

-- Fulfil the forward declarations the fs/permission handlers depend on.
-- Resolve symlinks so the agent's path (e.g. /private/var on macOS) matches a
-- buffer opened under its aliased path (/var).
local function realpath(p)
	return vim.uv.fs_realpath(p) or vim.fs.normalize(p)
end

loaded_buf = function(path)
	local target = realpath(path)
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		local name = vim.api.nvim_buf_get_name(b)
		if vim.api.nvim_buf_is_loaded(b) and name ~= "" and realpath(name) == target then
			return b
		end
	end
end

chat_by_session = function(sid)
	for _, c in pairs(chats) do
		if c.sessionId == sid then
			return c
		end
	end
end

--- Fold an incoming text delta into the last entry of `kind`, or start one.
local function accrue(chat, kind, delta)
	local last = chat.entries[#chat.entries]
	if last and last.kind == kind then
		last.text = last.text .. delta
	else
		chat.entries[#chat.entries + 1] = { kind = kind, text = delta, turn = chat.turn }
	end
end

local TOOL_ICON = { pending = "○", in_progress = "◐", completed = "●", failed = "✗" }
local PLAN_MARK = { pending = "[ ]", in_progress = "[~]", completed = "[x]" }

--- Render the whole buffer from the model. Model is source of truth, so this is
--- idempotent and safe to call on every streamed delta.
local function render(chat)
	local buf = chat.buf
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	local lines = {}
	local function push(s)
		lines[#lines + 1] = s
	end
	local function push_text(text)
		for _, l in ipairs(vim.split(text, "\n", { plain = true })) do
			push(l)
		end
	end

	local es = chat.entries
	local function render_user(e)
		push(USER_HEADER)
		push("")
		for _, label in ipairs(e.refs or {}) do
			push("> 📎 " .. label)
		end
		if e.refs and #e.refs > 0 then
			push("")
		end
		push_text(e.text)
		push("")
	end
	local function render_assistant(e)
		push("## Claude")
		push("")
		push_text(e.text)
		push("")
	end
	local function render_thought(e)
		push("> 💭 _thinking_")
		for _, l in ipairs(vim.split(e.text, "\n", { plain = true })) do
			push("> " .. l)
		end
		push("")
	end
	local function render_tool(e)
		local icon = TOOL_ICON[e.status] or "○"
		local kind = e.tool_kind and (" `" .. e.tool_kind .. "`") or ""
		push(string.format("%s **%s**%s", icon, e.title or "tool", kind))
		push("")
	end
	local function render_plan(e)
		push("### Plan")
		for _, item in ipairs(e.entries or {}) do
			push(string.format("- %s %s", PLAN_MARK[item.status] or "[ ]", item.content or ""))
		end
		push("")
	end
	local function render_tool_summary(count, failed)
		local note = failed > 0 and string.format(", %d failed", failed) or ""
		push(string.format("› _%d tool call%s%s_", count, count == 1 and "" or "s", note))
		push("")
	end
	-- A horizontal rule (blank-padded so markview renders it as a divider, not a
	-- setext heading) delimiting turns and the input region.
	local function separator()
		push("---")
		push("")
	end

	-- Group entries by turn. A completed turn (older than the active one, or the
	-- active one once idle) collapses in quiet mode to: the question, one dim
	-- "N tool calls" line, and the final answer -- so the interleaved narration
	-- and tool chatter don't bury what's actionable. The in-flight turn, and any
	-- turn in verbose mode, render every step live.
	local wrote = false
	local i = 1
	while i <= #es do
		local t = es[i].turn
		local j = i
		while j <= #es and es[j].turn == t do
			j = j + 1
		end
		if wrote then
			separator()
		end
		local complete = (chat.status ~= "busy") or (t ~= nil and t < chat.turn)
		local final_assist
		for k = j - 1, i, -1 do
			if es[k].kind == "assistant" then
				final_assist = k
				break
			end
		end

		if chat.verbose or not complete then
			local k = i
			while k < j do
				local e = es[k]
				if e.kind == "user" then
					render_user(e)
					k = k + 1
				elseif e.kind == "assistant" then
					render_assistant(e)
					k = k + 1
				elseif e.kind == "thought" then
					render_thought(e)
					k = k + 1
				elseif e.kind == "plan" then
					render_plan(e)
					k = k + 1
				elseif e.kind == "tool" and chat.verbose then
					render_tool(e)
					k = k + 1
				elseif e.kind == "tool" then
					local count, failed = 0, 0
					while k < j and es[k].kind == "tool" do
						count = count + 1
						if es[k].status == "failed" then
							failed = failed + 1
						end
						k = k + 1
					end
					render_tool_summary(count, failed)
				else
					k = k + 1
				end
			end
		else
			local count, failed = 0, 0
			for k = i, j - 1 do
				local e = es[k]
				if e.kind == "user" then
					render_user(e)
				elseif e.kind == "tool" then
					count = count + 1
					if e.status == "failed" then
						failed = failed + 1
					end
				end
			end
			if count > 0 then
				render_tool_summary(count, failed)
			end
			if final_assist then
				render_assistant(es[final_assist])
			end
		end
		wrote = true
		i = j
	end

	if chat.status == "busy" then
		push("_working… (`<C-c>` to cancel)_")
	else
		if wrote then
			separator()
		end
		if chat.pending_refs and #chat.pending_refs > 0 then
			push("### 📎 attached")
			for _, r in ipairs(chat.pending_refs) do
				push("- " .. r.label)
			end
			push("")
		end
		push(INPUT_MARKER)
		push("")
		push("")
	end

	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = chat.status ~= "busy"
	-- Our own renders shouldn't leave the buffer "dirty" (avoids E37 on quit);
	-- only your unsent typing marks it modified again.
	vim.bo[buf].modified = false
end

local function schedule_render(chat)
	if chat.redraw_scheduled then
		return
	end
	chat.redraw_scheduled = true
	vim.schedule(function()
		chat.redraw_scheduled = false
		render(chat)
	end)
end

--- Apply one session/update to the chat model.
local function apply_update(chat, u)
	local su = u.sessionUpdate
	if su == "agent_message_chunk" and u.content then
		accrue(chat, "assistant", u.content.text or "")
	elseif su == "agent_thought_chunk" and u.content then
		accrue(chat, "thought", u.content.text or "")
	elseif su == "tool_call" then
		-- The bridge emits tool_call twice per id (placeholder, then resolved);
		-- upsert so it's one entry, not a duplicate line.
		local e = u.toolCallId and chat.tool_index[u.toolCallId]
		if e then
			e.title = u.title or e.title
			e.tool_kind = u.kind or e.tool_kind
			e.status = u.status or e.status
		else
			e = { kind = "tool", id = u.toolCallId, title = u.title, tool_kind = u.kind, status = u.status or "pending", turn = chat.turn }
			chat.entries[#chat.entries + 1] = e
			if u.toolCallId then
				chat.tool_index[u.toolCallId] = e
			end
		end
	elseif su == "tool_call_update" then
		local e = u.toolCallId and chat.tool_index[u.toolCallId]
		if e then
			if u.status then
				e.status = u.status
			end
			if u.title then
				e.title = u.title
			end
		end
	elseif su == "plan" then
		if not chat.plan then
			chat.plan = { kind = "plan", entries = {}, turn = chat.turn }
			chat.entries[#chat.entries + 1] = chat.plan
		end
		chat.plan.entries = u.entries or {}
	elseif su == "available_commands_update" then
		chat.commands = u.availableCommands
		if u.availableCommands and #u.availableCommands > 0 then
			command_cache = u.availableCommands
		end
	end
end

----------------------------------------------------------------- chat window

local win_for_buf = require("tt.nvim_utils").vim_util.win_for_buf

--- Put the cursor at the end of the input region. Enters insert mode only when
--- `enter_insert` is set (opening/attaching), not e.g. after a response -- so
--- you land in normal mode to read and navigate.
local function focus_input(chat, enter_insert)
	local win = win_for_buf(chat.buf)
	if not win or chat.status == "busy" then
		return
	end
	local last = vim.api.nvim_buf_line_count(chat.buf)
	vim.api.nvim_win_set_cursor(win, { last, 0 })
	if vim.api.nvim_get_current_win() == win then
		-- Force the mode explicitly: on a response we want normal even if the
		-- message was sent from insert (e.g. <C-s>).
		if enter_insert then
			vim.cmd.startinsert()
		else
			vim.cmd.stopinsert()
		end
	end
end

--- omnifunc for chat buffers: completes `/slash-commands` from the agent's
--- advertised command list (falls back to the module cache so it works on a
--- chat's first message). Set as `omnifunc`; also auto-triggered on `/`.
function M.complete(findstart, base)
	local chat = chats[vim.api.nvim_get_current_buf()]
	local cmds = (chat and chat.commands) or command_cache
	if findstart == 1 then
		local col = vim.fn.col(".")
		local before = vim.api.nvim_get_current_line():sub(1, col - 1)
		local slash = before:find("/%S*$")
		-- Only a command position: the `/token` is the first thing on the line.
		if slash and before:sub(1, slash - 1):match("^%s*$") then
			return slash - 1
		end
		return -3 -- cancel silently, leave other completion alone
	end
	local items = {}
	for _, c in ipairs(cmds or {}) do
		local word = "/" .. c.name
		if base == "" or vim.startswith(word, base) then
			items[#items + 1] = {
				word = word,
				abbr = word,
				menu = ((c.description or ""):gsub("%s+", " ")):sub(1, 50),
				info = c.description or "",
			}
		end
	end
	return items
end

--- Extract the text the user typed in the trailing input region.
local function read_input(chat)
	local lines = vim.api.nvim_buf_get_lines(chat.buf, 0, -1, false)
	local start
	for i = #lines, 1, -1 do
		if lines[i] == INPUT_MARKER then
			start = i
			break
		end
	end
	if not start then
		return ""
	end
	local body = {}
	for i = start + 1, #lines do
		body[#body + 1] = lines[i]
	end
	return (table.concat(body, "\n"):gsub("^%s+", ""):gsub("%s+$", ""))
end

--- Toggle markview rendering for a chat buffer around a turn: disabled while the
--- agent streams (no repaint jank on the frequent full-buffer re-renders),
--- re-enabled when the turn ends (also a visible "agent is done" cue). No-ops if
--- markview isn't present or attached.
local function markview_render(buf, on)
	pcall(function()
		require("markview.actions")[on and "enable" or "disable"](buf)
	end)
end

--- Send the current input as a prompt (creating the session on first use).
function M.submit(chat)
	if chat.status == "busy" then
		vim.notify("acp: turn in progress", vim.log.levels.WARN)
		return
	end
	local text = read_input(chat)
	local refs = chat.pending_refs or {}
	if text == "" and #refs == 0 then
		return
	end

	-- Prompt = queued resource blocks first, then the typed text.
	local blocks = {}
	local labels = {}
	for _, r in ipairs(refs) do
		blocks[#blocks + 1] = r.block
		labels[#labels + 1] = r.label
	end
	if text ~= "" then
		blocks[#blocks + 1] = { type = "text", text = text }
	end
	chat.pending_refs = {}

	-- New turn: its entries are tagged with this id so render() can group and
	-- collapse it once complete. Fresh plan per turn.
	chat.turn = chat.turn + 1
	chat.plan = nil
	chat.entries[#chat.entries + 1] = { kind = "user", text = text, refs = labels, turn = chat.turn }
	chat.status = "busy"
	last_chat_buf = chat.buf
	render(chat)
	markview_render(chat.buf, false) -- pause rendering; raw markdown = "working"

	local function go()
		send_prompt(chat.sessionId, blocks, function(stop)
			vim.schedule(function()
				chat.status = "idle"
				if stop and stop ~= "end_turn" then
					chat.entries[#chat.entries + 1] = { kind = "assistant", text = "_[" .. stop .. "]_", turn = chat.turn }
				end
				render(chat)
				markview_render(chat.buf, true) -- re-render; rendered = "done"
				focus_input(chat)
			end)
		end)
	end

	if chat.sessionId then
		go()
	else
		new_session(chat.root, function(u)
			apply_update(chat, u)
			schedule_render(chat)
		end, function(sessionId)
			if not sessionId then
				chat.status = "idle"
				render(chat)
				markview_render(chat.buf, true)
				return
			end
			chat.sessionId = sessionId
			go()
		end)
	end
end

function M.cancel(chat)
	if chat.status == "busy" and chat.sessionId then
		cancel(chat.sessionId)
	end
end

function M.toggle_accept(chat)
	chat.accept_edits = not chat.accept_edits
	vim.notify("acp: accept-edits " .. (chat.accept_edits and "on" or "off"))
end

--- Toggle the full step-by-step trace. Off (default) collapses completed turns
--- to the question + a "N tool calls" line + the final answer; on shows every
--- intermediate message, thought, tool call and plan.
function M.toggle_verbose(chat)
	chat.verbose = not chat.verbose
	render(chat)
	vim.notify("acp: verbose trace " .. (chat.verbose and "on" or "off"))
end

--- The chat owning the current buffer, if any.
function M.current_chat()
	return chats[vim.api.nvim_get_current_buf()]
end

--- Create a new chat buffer for `root` and open it in a right split.
function M.new_chat(root)
	root = root or vim.fs.root(0, { ".git", "package.json", "Cargo.toml", "go.mod" }) or vim.uv.cwd()
	chat_counter = chat_counter + 1
	local buf = vim.api.nvim_create_buf(false, true)
	local chat = {
		buf = buf,
		root = root,
		id = chat_counter,
		sessionId = nil,
		status = "idle",
		accept_edits = false,
		verbose = false,
		turn = 0,
		entries = {},
		pending_refs = {},
		tool_index = {},
		plan = nil,
		commands = nil,
		redraw_scheduled = false,
	}
	chats[buf] = chat
	last_chat_buf = buf

	-- acwrite (not nofile) so `:w` is handled by our BufWriteCmd instead of
	-- being rejected with E382.
	vim.bo[buf].buftype = "acwrite"
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "markdown"
	vim.b[buf].acp_chat = true
	vim.bo[buf].omnifunc = "v:lua.require'tt.plugin.acp'.complete"
	pcall(vim.api.nvim_buf_set_name, buf, string.format("acp://%s/%d", vim.fs.basename(root), chat.id))

	-- Send by saving the buffer (`:w`). <CR> is left free for newlines in your
	-- message. Buffer-local BufWriteCmd rather than a name pattern, since the
	-- acp:// buffer name gets path-normalized.
	vim.api.nvim_create_autocmd("BufWriteCmd", {
		buffer = buf,
		callback = function()
			M.submit(chat)
			vim.bo[buf].modified = false
		end,
	})

	local opts = { buffer = buf, silent = true }
	vim.keymap.set("n", "<C-c>", function()
		M.cancel(chat)
	end, vim.tbl_extend("force", opts, { desc = "acp: cancel turn" }))
	vim.keymap.set("n", "Q", function()
		M.cancel(chat)
	end, vim.tbl_extend("force", opts, { desc = "acp: cancel turn" }))
	vim.keymap.set("n", "ga", function()
		M.toggle_accept(chat)
	end, vim.tbl_extend("force", opts, { desc = "acp: toggle accept-edits" }))
	vim.keymap.set("n", "gV", function()
		M.toggle_verbose(chat)
	end, vim.tbl_extend("force", opts, { desc = "acp: toggle verbose tools" }))
	-- Typing `/` at the start of a message pops the slash-command menu.
	vim.keymap.set("i", "/", function()
		local before = vim.api.nvim_get_current_line():sub(1, vim.fn.col(".") - 1)
		return before:match("^%s*$") and "/<C-x><C-o>" or "/"
	end, vim.tbl_extend("force", opts, { expr = true, desc = "acp: slash-command completion" }))

	vim.cmd("botright vsplit")
	vim.api.nvim_win_set_buf(0, buf)
	render(chat)
	focus_input(chat, true)
	return chat
end

------------------------------------------------------------ context & capture

--- The chat to act on for context/save: the current buffer's chat, else the
--- most-recently-used one (if still alive), else nil.
local function resolve_chat()
	local c = chats[vim.api.nvim_get_current_buf()]
	if c then
		return c
	end
	if last_chat_buf and chats[last_chat_buf] and vim.api.nvim_buf_is_valid(last_chat_buf) then
		return chats[last_chat_buf]
	end
	return nil
end

--- Make `chat` visible and current, opening a split if it has no window.
local function show_chat(chat)
	local win = win_for_buf(chat.buf)
	if win then
		vim.api.nvim_set_current_win(win)
	else
		vim.cmd("botright vsplit")
		vim.api.nvim_win_set_buf(0, chat.buf)
	end
end

--- Build an embedded-resource ref for a chunk of a file. `label` is shown in
--- the transcript; `name` (defaults to `label`) is the file the chat is named
--- after once this ref is attached.
local function file_ref(path, text, label, name)
	return {
		label = label,
		name = name or label,
		block = { type = "resource", resource = { uri = "file://" .. path, mimeType = "text/plain", text = text } },
	}
end

--- Name the chat after a file, falling back to an id-suffixed form on clash.
local function set_chat_name(chat, file)
	local base = "acp://" .. file
	if not pcall(vim.api.nvim_buf_set_name, chat.buf, base) then
		pcall(vim.api.nvim_buf_set_name, chat.buf, base .. "#" .. chat.id)
	end
end

--- Queue a ref on the target chat, reveal it, and drop the cursor in the input.
local function attach_ref(ref)
	local chat = resolve_chat()
	if chat then
		show_chat(chat)
	else
		chat = M.new_chat()
	end
	chat.pending_refs[#chat.pending_refs + 1] = ref
	last_chat_buf = chat.buf
	-- Name the chat after the file just loaded into context.
	if ref.name then
		set_chat_name(chat, ref.name)
	end
	render(chat)
	focus_input(chat, true)
end

--- Attach the current (code) buffer as context.
function M.ref_buffer()
	local src = vim.api.nvim_get_current_buf()
	if chats[src] then
		vim.notify("acp: current buffer is a chat", vim.log.levels.WARN)
		return
	end
	local path = vim.api.nvim_buf_get_name(src)
	if path == "" then
		vim.notify("acp: current buffer has no file", vim.log.levels.WARN)
		return
	end
	local text = table.concat(vim.api.nvim_buf_get_lines(src, 0, -1, false), "\n")
	attach_ref(file_ref(path, text, vim.fn.fnamemodify(path, ":.")))
end

--- Attach the last visual selection as context (with a file:line label).
function M.send_selection()
	local src = vim.api.nvim_get_current_buf()
	if chats[src] then
		return
	end
	local s = vim.fn.getpos("'<")
	local e = vim.fn.getpos("'>")
	local lines = vim.api.nvim_buf_get_lines(src, s[2] - 1, e[2], false)
	if #lines == 0 then
		return
	end
	local path = vim.api.nvim_buf_get_name(src)
	local rel = vim.fn.fnamemodify(path, ":.")
	local label = string.format("%s:%d-%d", rel, s[2], e[2])
	local text = "// " .. label .. "\n" .. table.concat(lines, "\n")
	attach_ref(file_ref(path, text, label, rel))
end

local function last_answer(chat)
	for i = #chat.entries, 1, -1 do
		if chat.entries[i].kind == "assistant" then
			return chat.entries[i].text
		end
	end
end

--- Flatten the conversation to clean markdown (user + assistant turns only).
local function transcript_md(chat)
	local out = {}
	for _, e in ipairs(chat.entries) do
		if e.kind == "user" then
			out[#out + 1] = "## You\n\n" .. e.text
		elseif e.kind == "assistant" then
			out[#out + 1] = "## Claude\n\n" .. e.text
		end
	end
	return table.concat(out, "\n\n")
end

--- Capture a chat's last answer (or whole transcript) into a buffer/file.
---@param opts { all: boolean|nil, path: string|nil }
function M.save(opts)
	opts = opts or {}
	local chat = resolve_chat()
	if not chat then
		vim.notify("acp: no chat to save", vim.log.levels.WARN)
		return
	end
	local content = opts.all and transcript_md(chat) or last_answer(chat)
	if not content or content == "" then
		vim.notify("acp: nothing to save yet", vim.log.levels.WARN)
		return
	end
	local lines = vim.split(content, "\n", { plain = true })

	if opts.path and opts.path ~= "" then
		local path = opts.path
		if path:sub(1, 1) == "~" then
			path = vim.fn.expand(path)
		end
		if not path:match("^/") then -- bare name -> stash under ~/notes
			path = vim.fs.normalize("~/notes/" .. path)
		end
		vim.fs.mkdir(vim.fs.dirname(path), { parents = true })
		vim.fn.writefile(lines, path)
		vim.cmd("split " .. vim.fn.fnameescape(path))
		vim.notify("acp: saved → " .. path)
	else
		-- Scratch reference buffer; user decides whether to :w it.
		vim.cmd("botright split")
		vim.cmd("enew")
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
		vim.bo.filetype = "markdown"
		vim.bo.bufhidden = "hide"
	end
end

--- Send `text` as a one-shot prompt to the current/most-recent chat (or a new
--- one). Used by the *.todo write handler for `?`-prefixed rough notes.
function M.send(text)
	local chat = resolve_chat()
	if chat then
		show_chat(chat)
	else
		chat = M.new_chat()
	end
	vim.api.nvim_buf_set_lines(chat.buf, -1, -1, false, vim.split(text, "\n", { plain = true }))
	M.submit(chat)
end

--- Pick a live chat and jump to it.
function M.list_chats()
	local items = {}
	for buf, c in pairs(chats) do
		if vim.api.nvim_buf_is_valid(buf) then
			items[#items + 1] = c
		end
	end
	if #items == 0 then
		vim.notify("acp: no chats open", vim.log.levels.INFO)
		return
	end
	table.sort(items, function(a, b)
		return a.id < b.id
	end)
	vim.ui.select(items, {
		prompt = "ACP chats:",
		format_item = function(c)
			local st = c.status == "busy" and "●" or "○"
			local title = "(new)"
			for _, e in ipairs(c.entries) do
				if e.kind == "user" then
					title = vim.split(e.text, "\n", { plain = true })[1]
					break
				end
			end
			return string.format("%s #%d  %s  %s", st, c.id, vim.fs.basename(c.root), title)
		end,
	}, function(choice)
		if choice then
			show_chat(choice)
			focus_input(choice)
		end
	end)
end

--- Terminate the bridge subprocess (and thus all sessions). Called on quit.
function M.shutdown()
	if client and client.job and client.job > 0 then
		pcall(vim.fn.jobstop, client.job)
		pcall(vim.fn.jobwait, { client.job }, 1000)
	end
	client = nil
end

--- Report bridge/session state and list every running bridge process so you
--- can spot orphans (pids other than the one we track).
function M.info()
	local lines = {}
	if client and client.job and client.job > 0 then
		local ok, pid = pcall(vim.fn.jobpid, client.job)
		lines[#lines + 1] = string.format("tracked bridge: job=%d pid=%s", client.job, ok and pid or "?")
		local n = 0
		for _ in pairs(client.sessions) do
			n = n + 1
		end
		lines[#lines + 1] = "sessions: " .. n
	else
		lines[#lines + 1] = "tracked bridge: none (not spawned)"
	end
	local pgrep = vim.system({ "pgrep", "-fl", "claude-code-acp" }, { text = true }):wait()
	local procs = vim.split(vim.trim(pgrep.stdout or ""), "\n", { trimempty = true })
	lines[#lines + 1] = "running bridge processes:"
	if #procs == 0 then
		lines[#lines + 1] = "  (none)"
	else
		for _, p in ipairs(procs) do
			lines[#lines + 1] = "  " .. p
		end
	end
	vim.notify(table.concat(lines, "\n"))
end

--- Open the bridge's recent stderr in a scratch buffer (see M.debug for live).
function M.show_log()
	local log = (client and client.stderr_log) or {}
	if #log == 0 then
		vim.notify("acp: no bridge log yet")
		return
	end
	vim.cmd("botright split")
	vim.cmd("enew")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, log)
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.filetype = "log"
end

----------------------------------------------------------------- persistence

local function session_dir()
	local dir = vim.fs.normalize(vim.fn.stdpath("state") .. "/acp")
	vim.fs.mkdir(dir, { parents = true })
	return dir
end

--- Save a chat to disk so it can be reopened (and its agent session resumed)
--- after nvim restarts. Only chats that have sent a turn (have a sessionId) can
--- be persisted; the file is keyed by that sessionId.
function M.persist(chat)
	chat = chat or resolve_chat()
	if not chat then
		vim.notify("acp: no chat to persist", vim.log.levels.WARN)
		return
	end
	if not chat.sessionId then
		vim.notify("acp: nothing to persist yet (send a message first)", vim.log.levels.WARN)
		return
	end
	local rec = {
		version = 1,
		name = vim.api.nvim_buf_is_valid(chat.buf) and vim.api.nvim_buf_get_name(chat.buf) or nil,
		root = chat.root,
		sessionId = chat.sessionId,
		accept_edits = chat.accept_edits,
		verbose = chat.verbose,
		turn = chat.turn,
		updated = os.time(),
		entries = chat.entries,
	}
	local path = session_dir() .. "/" .. chat.sessionId .. ".json"
	local ok, err = pcall(function()
		vim.fn.writefile({ vim.json.encode(rec) }, path)
	end)
	if ok then
		vim.notify("acp: session saved")
	else
		vim.notify("acp: save failed: " .. tostring(err), vim.log.levels.ERROR)
	end
end

--- Recreate a chat from a saved record and resume its agent session.
local function restore(rec)
	local chat = M.new_chat(rec.root)
	chat.entries = rec.entries or {}
	chat.turn = rec.turn or 0
	chat.accept_edits = rec.accept_edits or false
	chat.verbose = rec.verbose or false
	chat.sessionId = rec.sessionId
	if rec.name then
		if not pcall(vim.api.nvim_buf_set_name, chat.buf, rec.name) then
			pcall(vim.api.nvim_buf_set_name, chat.buf, rec.name .. "#" .. chat.id)
		end
	end
	render(chat)
	markview_render(chat.buf, true)
	-- Reconnect the live Claude session so the conversation can continue.
	load_session(rec.sessionId, rec.root, function(u)
		apply_update(chat, u)
		schedule_render(chat)
	end, function(sid)
		vim.schedule(function()
			vim.notify(sid and "acp: session resumed" or "acp: reopened transcript (resume failed)")
		end)
	end)
	return chat
end

--- Pick a saved session and reopen it.
function M.sessions()
	local dir = session_dir()
	local recs = {}
	for name, ty in vim.fs.dir(dir) do
		if ty == "file" and name:match("%.json$") then
			local f = vim.fs.joinpath(dir, name)
			local ok, data = pcall(function()
				return vim.json.decode(table.concat(vim.fn.readfile(f), "\n"))
			end)
			if ok and type(data) == "table" and data.sessionId then
				recs[#recs + 1] = data
			end
		end
	end
	if #recs == 0 then
		vim.notify("acp: no saved sessions", vim.log.levels.INFO)
		return
	end
	table.sort(recs, function(a, b)
		return (a.updated or 0) > (b.updated or 0)
	end)

	local items = {}
	for _, rec in ipairs(recs) do
		local title = "(empty)"
		for _, e in ipairs(rec.entries or {}) do
			if e.kind == "user" and e.text and e.text ~= "" then
				title = vim.split(e.text, "\n", { plain = true })[1]
				break
			end
		end
		local age = rec.updated and os.date("%Y-%m-%d %H:%M", rec.updated) or "?"
		items[#items + 1] = {
			text = title,
			hint = vim.fs.basename(rec.root or "") .. " · " .. age,
			value = rec,
		}
	end
	require("tt.pick").numbered(items, {
		prompt = "ACP saved sessions",
		on_choice = function(rec)
			restore(rec)
		end,
	})
end

------------------------------------------------------------------- smoke test

local function buf_append(buf, delta)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	local parts = vim.split(delta, "\n", { plain = true })
	local last = vim.api.nvim_buf_line_count(buf)
	local tail = vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1] or ""
	local new = { tail .. parts[1] }
	for i = 2, #parts do
		new[#new + 1] = parts[i]
	end
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, last - 1, last, false, new)
	vim.bo[buf].modifiable = false
end

--- Phase 1 smoke test, kept for debugging the transport in isolation.
function M.ping()
	vim.cmd("botright new")
	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "markdown"
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "# acp ping", "", "> connecting…", "" })
	vim.bo[buf].modifiable = false
	local root = vim.fs.root(0, { ".git" }) or vim.uv.cwd()
	new_session(root, function(update)
		vim.schedule(function()
			local su = update.sessionUpdate
			if (su == "agent_message_chunk" or su == "agent_thought_chunk") and update.content then
				buf_append(buf, update.content.text or "")
			end
		end)
	end, function(sessionId)
		if not sessionId then
			return
		end
		send_prompt(sessionId, { { type = "text", text = "Reply with exactly the single word: PONG." } }, function(stop)
			vim.schedule(function()
				buf_append(buf, "\n\n> _turn ended: " .. tostring(stop) .. "_")
			end)
		end)
	end)
end

---------------------------------------------------------------------- wiring

function M.init()
	-- Chat buffers wrap (soft, at word boundaries, with hanging indent) wherever
	-- they're shown. wrap is window-local, so key off the buffer flag on display.
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = vim.api.nvim_create_augroup("acp_chat_win", { clear = true }),
		callback = function(ev)
			if not vim.b[ev.buf].acp_chat then
				return
			end
			local win = vim.fn.bufwinid(ev.buf)
			if win ~= -1 then
				vim.wo[win].wrap = true
				vim.wo[win].linebreak = true
				vim.wo[win].breakindent = true
			end
		end,
	})

	-- Make sure the bridge dies with nvim (covers the clean-exit path
	-- explicitly; a SIGKILL of nvim still can't be caught -- use :AgentStatus
	-- to find and :AgentStop to reap any survivor).
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("acp_shutdown", { clear = true }),
		callback = function()
			M.shutdown()
		end,
	})

	local cmd = vim.api.nvim_create_user_command

	cmd("AgentStatus", function()
		M.info()
	end, { desc = "Report ACP bridge/session state and list bridge processes" })
	cmd("AgentStop", function()
		M.shutdown()
		vim.notify("acp: bridge stopped")
	end, { desc = "Terminate the ACP bridge subprocess" })
	cmd("AgentLog", function()
		M.show_log()
	end, { desc = "Open the ACP bridge's recent stderr log" })
	cmd("AgentDebug", function()
		M.debug = not M.debug
		vim.notify("acp: live bridge debug " .. (M.debug and "on" or "off"))
	end, { desc = "Toggle live echo of the ACP bridge's stderr" })

	cmd("Agent", function()
		M.new_chat()
	end, { desc = "Open a new ACP chat buffer" })
	cmd("AgentChats", function()
		M.list_chats()
	end, { desc = "Pick a live ACP chat" })

	cmd("AgentAccept", function()
		local chat = M.current_chat()
		if chat then
			M.toggle_accept(chat)
		else
			vim.notify("acp: not in a chat buffer", vim.log.levels.WARN)
		end
	end, { desc = "Toggle accept-edits for the current ACP chat" })

	cmd("AgentVerbose", function()
		local chat = M.current_chat()
		if chat then
			M.toggle_verbose(chat)
		else
			vim.notify("acp: not in a chat buffer", vim.log.levels.WARN)
		end
	end, { desc = "Toggle the full step-by-step trace for the current ACP chat" })

	cmd("AgentRef", function()
		M.ref_buffer()
	end, { desc = "Attach the current buffer to the ACP chat as context" })
	cmd("AgentSend", function()
		M.send_selection()
	end, { range = true, desc = "Attach the visual selection to the ACP chat" })
	cmd("AgentSave", function(o)
		M.save({ all = o.bang, path = o.args })
	end, { bang = true, nargs = "?", complete = "file", desc = "Save the last ACP answer (! = whole transcript)" })

	cmd("AgentPersist", function()
		M.persist()
	end, { desc = "Save the current ACP chat to disk (resumable after restart)" })
	cmd("AgentSessions", function()
		M.sessions()
	end, { desc = "Pick a saved ACP session to reopen and resume" })

	cmd("AgentPing", function()
		M.ping()
	end, { desc = "ACP smoke test: ping Claude Code over the bridge" })

end

return M
