-- pi-acp translates ACP v1 into the installed pi executable's RPC protocol.

local M = {}

-- When true, the bridge's stderr is echoed live via vim.notify. Off by default
-- (the bridge is chatty); recent stderr is always kept for |:AgentLog|.
M.debug = false

local DEFAULT_BRIDGE_CMD = { "npx", "--yes", "pi-acp@0.0.34" }

-- g:acp_bridge_cmd must run an ACP server, not pi --mode rpc directly.
local function bridge_cmd()
	local override = vim.g.acp_bridge_cmd
	if type(override) == "table" and #override > 0 then
		return override
	elseif type(override) == "string" and override ~= "" then
		return { "sh", "-c", override }
	end
	return DEFAULT_BRIDGE_CMD
end

local PROTOCOL_VERSION = 1
local RESPONSE_FORMAT = [[Response formatting for this Neovim ACP chat:
This interface displays plain text without Markdown rendering.
Use short paragraphs and blank lines; brief plain-text section labels are fine.
Use simple "-" bullets or numbered steps, and keep lists shallow.
Inline backticks and fenced code blocks are fine for code, commands, and exact data.
Do not use Markdown or ASCII tables; use labeled bullet lists for comparisons.
Avoid decorative bold/italics, heading markup, HTML layouts, images, LaTeX,
footnotes, reference links, box-drawing diagrams, and decorative icons.
Write links as readable labels followed by plain URLs.
Apply these rules to explanatory replies, not file contents or exact code,
data, or quotations required by the task.
Perform the user's request; do not acknowledge or discuss these formatting instructions.]]

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
local bridge_log = {}

local function bridge_exited(c, code)
	if client == c then
		client = nil
	end
	local pending = c.pending
	c.pending = {}
	for _, cb in pairs(pending) do
		vim.schedule(function()
			cb(nil, { code = -32000, message = "ACP bridge exited (" .. tostring(code) .. "); see :AgentLog" })
		end)
	end
end

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
	local c = {
		job = 0,
		stdout = "",
		next_id = 1,
		pending = {},
		initialized = false,
		init_caps = nil,
		sessions = {},
		stderr_log = {},
	}
	client = c
	bridge_log = c.stderr_log
	local job = vim.fn.jobstart(bridge_cmd(), {
		on_stdout = function(job_id, data)
			if client == c then
				on_stdout(job_id, data)
			end
		end,
		on_stderr = function(_, data)
			-- Keep a bounded ring of stderr for :AgentLog; only surface it to
			-- :messages when M.debug is on, so the bridge doesn't spam you.
			if client ~= c then
				return
			end
			local log = c.stderr_log
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
		on_exit = function(_, code)
			bridge_exited(c, code)
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
		cb(nil)
		return
	end
	if c.initialized then
		cb(c)
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
			cb(nil)
			return
		end
		c.initialized = true
		c.init_caps = result and result.agentCapabilities
		cb(c)
	end)
end

local function new_session(cwd, on_update, cb)
	ensure_initialized(function(c)
		if not c then
			cb(nil, nil)
			return
		end
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
	ensure_initialized(function(c)
		if not c then
			cb(nil, nil)
			return
		end
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

local chat_view = require("tt.plugin.acp_view")
local chat_highlights = require("tt.plugin.acp_highlights")
local INPUT_MARKER = chat_view.input_marker
local view_ns = vim.api.nvim_create_namespace("tt_acp_view")

local ping_running = false
---@param chat? table
local function another_running(chat)
	if ping_running then
		vim.notify("acp: wait for the active ping before switching agent sessions", vim.log.levels.WARN)
		return true
	end
	for _, other in pairs(chats) do
		if other ~= chat and vim.api.nvim_buf_is_valid(other.buf) and other.status == "busy" then
			vim.notify("acp: finish or cancel the active turn before switching agent sessions", vim.log.levels.WARN)
			return true
		end
	end
	return false
end

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

local function render(chat)
	local buf = chat.buf
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	local lines, layout = chat_view.lines(chat)
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_clear_namespace(buf, view_ns, 0, -1)
	chat.messages = layout.messages
	for _, message in ipairs(chat.messages) do
		message.mark = vim.api.nvim_buf_set_extmark(buf, view_ns, message.row - 1, 0, { right_gravity = true })
	end
	chat.input_mark = nil
	if layout.input_row then
		chat.input_mark = vim.api.nvim_buf_set_extmark(buf, view_ns, layout.input_row - 1, 0, { right_gravity = true })
	end
	chat_highlights.apply(buf, layout.highlights)
	vim.bo[buf].modifiable = chat.status ~= "busy"
	-- Transcript updates must not trigger an unsaved-buffer warning.
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

local text_kinds = { agent_message_chunk = "assistant", agent_thought_chunk = "thought" }
local function update_text(chat, update)
	if update.content then
		accrue(chat, text_kinds[update.sessionUpdate], update.content.text or "")
	end
end

local function upsert_tool(chat, update)
	-- The bridge can send tool_call twice for one ID. Keep one entry per ID.
	local entry = update.toolCallId and chat.tool_index[update.toolCallId]
	if entry then
		entry.title = update.title or entry.title
		entry.tool_kind = update.kind or entry.tool_kind
		entry.status = update.status or entry.status
		return
	end
	entry = {
		kind = "tool",
		id = update.toolCallId,
		title = update.title,
		tool_kind = update.kind,
		status = update.status or "pending",
		turn = chat.turn,
	}
	chat.entries[#chat.entries + 1] = entry
	if update.toolCallId then
		chat.tool_index[update.toolCallId] = entry
	end
end

local function update_tool(chat, update)
	local entry = update.toolCallId and chat.tool_index[update.toolCallId]
	if not entry then
		return
	end
	if update.status then
		entry.status = update.status
	end
	if update.title then
		entry.title = update.title
	end
end

local function update_plan(chat, update)
	if not chat.plan then
		chat.plan = { kind = "plan", entries = {}, turn = chat.turn }
		chat.entries[#chat.entries + 1] = chat.plan
	end
	chat.plan.entries = update.entries or {}
end

local function update_commands(chat, update)
	chat.commands = update.availableCommands
	if update.availableCommands and #update.availableCommands > 0 then
		command_cache = update.availableCommands
	end
end

local update_handlers = {
	agent_message_chunk = update_text,
	agent_thought_chunk = update_text,
	tool_call = upsert_tool,
	tool_call_update = update_tool,
	plan = update_plan,
	available_commands_update = update_commands,
}

local function apply_update(chat, update)
	local handler = update_handlers[update.sessionUpdate]
	if handler then
		handler(chat, update)
	end
end

----------------------------------------------------------------- chat window

local vim_util = require("tt.nvim_utils").vim_util
local function win_for_buf(buf)
	return vim.fn.win_findbuf(buf)[1]
end

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

local function marked_row(chat, mark)
	if not mark then
		return
	end
	local position = vim.api.nvim_buf_get_extmark_by_id(chat.buf, view_ns, mark, {})
	if #position > 0 then
		return position[1] + 1
	end
end

--- The input anchor must not match prompt-like text in a message or draft.
local function read_input(chat)
	local row = marked_row(chat, chat.input_mark)
	if not row or vim.api.nvim_buf_get_lines(chat.buf, row - 1, row, false)[1] ~= INPUT_MARKER then
		return ""
	end
	local body = vim.api.nvim_buf_get_lines(chat.buf, row, -1, false)
	return (table.concat(body, "\n"):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function neighboring_row(rows, row, direction)
	if direction < 0 then
		for i = #rows, 1, -1 do
			if rows[i] < row then
				return rows[i]
			end
		end
	else
		for _, candidate in ipairs(rows) do
			if candidate > row then
				return candidate
			end
		end
	end
end

function M.jump_message(chat, direction)
	local rows = {}
	for _, message in ipairs(chat.messages) do
		local row = marked_row(chat, message.mark)
		if row then
			rows[#rows + 1] = row
		end
	end
	local row = vim.api.nvim_win_get_cursor(0)[1]
	for _ = 1, vim.v.count1 do
		local next_row = neighboring_row(rows, row, direction)
		if not next_row then
			break
		end
		row = next_row
	end
	vim.api.nvim_win_set_cursor(0, { row, 0 })
end

function M.message_menu(chat)
	if #chat.messages == 0 then
		return
	end
	local win = vim.api.nvim_get_current_win()
	local messages, labels = chat.messages, {}
	for _, message in ipairs(messages) do
		local text = message.entry.text
		local preview = text:sub(1, vim.str_byteindex(text, "utf-32", 80, false)):gsub("%s+", " ")
		labels[#labels + 1] = message.role .. ": " .. preview
	end
	vim.ui.select(labels, { prompt = "Messages:" }, function(_, index)
		local message = index and messages[index]
		if not message or not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= chat.buf then
			return
		end
		for _, current in ipairs(chat.messages) do
			if current.entry == message.entry then
				local row = marked_row(chat, current.mark)
				if row then
					vim.api.nvim_win_set_cursor(win, { row, 0 })
				end
				return
			end
		end
	end)
end

local function refresh_files()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local opts = vim.bo[buf]
			local autoread = opts.autoread
			if autoread == nil then
				autoread = vim.o.autoread
			end
			if autoread and not opts.modified and opts.buftype == "" then
				-- A buffer number prevents :checktime from waiting for the next input.
				vim.cmd("silent! checktime " .. buf)
			end
		end
	end
end

--- Send the current input as a prompt (creating the session on first use).
function M.submit(chat)
	if chat.status == "busy" then
		vim.notify("acp: turn in progress", vim.log.levels.WARN)
		return
	end
	-- pi-acp stops other pi processes when it creates or loads a session.
	if another_running(chat) then
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
	-- Slash-command arguments must stay exact for the adapter's command parser.
	if text:sub(1, 1) ~= "/" then
		blocks[#blocks + 1] = { type = "text", text = RESPONSE_FORMAT }
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

	local function go()
		send_prompt(chat.sessionId, blocks, function(stop)
			vim.schedule(function()
				chat.status = "idle"
				refresh_files()
				if stop and stop ~= "end_turn" then
					chat.entries[#chat.entries + 1] = { kind = "status", text = "[" .. stop .. "]", turn = chat.turn }
				end
				render(chat)
				focus_input(chat)
			end)
		end)
	end

	local function on_update(u)
		apply_update(chat, u)
		schedule_render(chat)
	end
	local function ready(sessionId)
		chat.sessionId = sessionId
		if not sessionId then
			chat.status = "idle"
			render(chat)
			return
		end
		go()
	end
	if chat.sessionId and client and client.sessions[chat.sessionId] then
		go()
	elseif chat.sessionId then
		load_session(chat.sessionId, chat.root, on_update, ready)
	else
		new_session(chat.root, on_update, ready)
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

	-- 'acwrite' permits BufWriteCmd; 'nofile' rejects :write with E382.
	vim.bo[buf].buftype = "acwrite"
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].swapfile = false
	vim.b[buf].acp_chat = true
	vim.bo[buf].omnifunc = "v:lua.require'tt.plugin.acp'.complete"
	pcall(vim.api.nvim_buf_set_name, buf, string.format("acp://%s/%d", vim.fs.basename(root), chat.id))

	-- ACP buffer names are normalized. Match the buffer handle, not the name.
	vim.api.nvim_create_autocmd("BufWriteCmd", {
		buf = buf,
		callback = function()
			M.submit(chat)
			vim.bo[buf].modified = false
		end,
	})

	local opts = { buf = buf, silent = true }
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
	vim.keymap.set("n", "[[", function()
		M.jump_message(chat, -1)
	end, vim.tbl_extend("force", opts, { desc = "acp: previous message" }))
	vim.keymap.set("n", "]]", function()
		M.jump_message(chat, 1)
	end, vim.tbl_extend("force", opts, { desc = "acp: next message" }))
	vim.keymap.set("n", "gO", function()
		M.message_menu(chat)
	end, vim.tbl_extend("force", opts, { desc = "acp: message list" }))
	-- Typing `/` at the start of a message pops the slash-command menu.
	vim.keymap.set("i", "/", function()
		local before = vim.api.nvim_get_current_line():sub(1, vim.fn.col(".") - 1)
		return before:match("^%s*$") and "/<C-x><C-o>" or "/"
	end, vim.tbl_extend("force", opts, { expr = true, desc = "acp: slash-command completion" }))

	vim.cmd("botright vsplit")
	vim.api.nvim_win_set_buf(0, buf)
	vim.bo[buf].filetype = "acp"
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

--- Capture a chat's last answer (or whole transcript) into a buffer/file.
---@param opts { all: boolean|nil, path: string|nil }
function M.save(opts)
	opts = opts or {}
	local chat = resolve_chat()
	if not chat then
		vim.notify("acp: no chat to save", vim.log.levels.WARN)
		return
	end
	local content = opts.all and chat_view.transcript(chat) or last_answer(chat)
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
		vim.notify("acp: saved: " .. path)
	else
		-- Scratch reference buffer; user decides whether to :w it (buftype "").
		vim_util.scratch_split(lines, { buftype = "", bufhidden = "hide", filetype = "acp" })
	end
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
			local st = c.status == "busy" and "[busy]" or "[idle]"
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
	local c = client
	if c and c.job > 0 then
		bridge_exited(c, "stopped")
		pcall(vim.fn.jobstop, c.job)
		pcall(vim.fn.jobwait, { c.job }, 1000)
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
	local cmd = bridge_cmd()
	local pat = (vim.g.acp_bridge_cmd == nil) and "pi-acp" or (cmd[#cmd] or "")
	local pgrep = vim.system({ "pgrep", "-fl", pat }, { text = true }):wait()
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
	local log = bridge_log
	if #log == 0 then
		vim.notify("acp: no bridge log yet")
		return
	end
	vim_util.scratch_split(log, { filetype = "log" })
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
		version = 2,
		bridge = bridge_cmd(),
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
	local same_bridge = vim.deep_equal(rec.bridge, bridge_cmd())
	if same_bridge and another_running() then
		return
	end
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
	-- A session ID from another agent cannot resume a pi session.
	if not same_bridge then
		chat.sessionId = nil
		vim.notify("acp: transcript reopened; different bridge, so the next message starts a new session")
		return chat
	end
	load_session(rec.sessionId, rec.root, function(u)
		apply_update(chat, u)
		schedule_render(chat)
	end, function(sid)
		chat.sessionId = sid
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
			hint = vim.fs.basename(rec.root or "") .. " - " .. age,
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

--- Check transport and authentication with one prompt.
function M.ping()
	if another_running() then
		return
	end
	vim.cmd("botright new")
	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "acp"
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "ACP ping", "", "Connecting...", "" })
	vim.bo[buf].modifiable = false
	local root = vim.fs.root(0, { ".git" }) or vim.uv.cwd()
	ping_running = true
	new_session(root, function(update)
		vim.schedule(function()
			local su = update.sessionUpdate
			if (su == "agent_message_chunk" or su == "agent_thought_chunk") and update.content then
				buf_append(buf, update.content.text or "")
			end
		end)
	end, function(sessionId)
		if not sessionId then
			ping_running = false
			return
		end
		send_prompt(sessionId, { { type = "text", text = "Reply with exactly the single word: PONG." } }, function(stop)
			ping_running = false
			vim.schedule(function()
				buf_append(buf, "\n\n[turn ended: " .. tostring(stop) .. "]")
			end)
		end)
	end)
end

---------------------------------------------------------------------- wiring

-- Reapply chat window options when a buffer is shown in a different split.
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = vim.api.nvim_create_augroup("acp_chat_win", { clear = true }),
	callback = function(ev)
		if vim.b[ev.buf].acp_chat or vim.bo[ev.buf].filetype == "acp" then
			chat_view.setup_window(ev.win)
		end
	end,
})
vim.api.nvim_create_autocmd("VimLeavePre", {
	group = vim.api.nvim_create_augroup("acp_shutdown", { clear = true }),
	callback = function()
		M.shutdown()
	end,
})

function M.init()
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
	end, { desc = "ACP smoke test: ping pi over the bridge" })
end

return M
