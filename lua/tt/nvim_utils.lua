--- NVIM SPECIFIC SHORTCUTS
vim = vim or {}
api = vim.api
fn = vim.fn
loop = vim.loop

local valid_modes = {
	n = "n",
	v = "v",
	x = "x",
	i = "i",
	o = "o",
	t = "t",
	c = "c",
	s = "s",
	-- :map! and :map
	["!"] = "!",
	[" "] = "",
}

function map_cmd(cmd_string, buflocal)
	return { ("<Cmd>%s<CR>"):format(cmd_string), noremap = true, buffer = buflocal }
end

function map_call(cmd_string, buflocal)
	return { ("%s<CR>"):format(cmd_string), noremap = true, buffer = buflocal }
end

function map_no_cr(cmd_string, buflocal)
	return { (":%s"):format(cmd_string), noremap = true, buffer = buflocal }
end

is_windows = loop.os_uname().version:match("Windows")
file_separator = is_windows and "\\" or "/"

function nvim_apply_mappings(mappings, default_options)
	-- May or may not be used.
	local current_bufnr = vim.api.nvim_get_current_buf()
	for key, options in pairs(mappings) do
		options = vim.tbl_extend("keep", options, default_options or {})
		local bufnr = current_bufnr
		-- TODO allow passing bufnr through options.buffer?
		-- protect against specifying 0, since it denotes current buffer in api by convention
		if type(options.buffer) == "number" and options.buffer ~= 0 then
			bufnr = options.buffer
		end
		local mode, mapping = key:match("^(.)(.+)$")
		assert(mode, "nvim_apply_mappings: invalid mode specified for keymapping " .. key)
		assert(valid_modes[mode], "nvim_apply_mappings: invalid mode specified for keymapping. mode=" .. mode)
		mode = valid_modes[mode]
		local rhs = options[1]
		-- Remove this because we're going to pass it straight to nvim_set_keymap
		options[1] = nil
		if type(rhs) == "function" then
			-- Use a value that won't be misinterpreted below since special keys
			-- like <CR> can be in key, and escaping those isn't easy.
			local escaped = escape_keymap(key)
			local key_mapping
			if options.dot_repeat then
				local key_function = rhs
				rhs = function()
					key_function()
					-- -- local repeat_expr = key_mapping
					-- local repeat_expr = mapping
					-- repeat_expr = vim.api.nvim_replace_termcodes(repeat_expr, true, true, true)
					-- nvim.fn["repeat#set"](repeat_expr, nvim.v.count)
					vim.fn["repeat#set"](vim.api.nvim_replace_termcodes(key_mapping, true, true, true), nvim.v.count)
				end
				options.dot_repeat = nil
			end
			if options.buffer then
				-- Initialize and establish cleanup
				if not LUA_BUFFER_MAPPING[bufnr] then
					LUA_BUFFER_MAPPING[bufnr] = {}
					-- Clean up our resources.
					vim.api.nvim_buf_attach(bufnr, false, {
						on_detach = function()
							LUA_BUFFER_MAPPING[bufnr] = nil
						end,
					})
				end
				LUA_BUFFER_MAPPING[bufnr][escaped] = rhs
				-- TODO HACK figure out why <Cmd> doesn't work in visual mode.
				if mode == "x" or mode == "v" then
					key_mapping = (":<C-u>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(bufnr, escaped)
				else
					key_mapping = ("<Cmd>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(bufnr, escaped)
				end
			else
				LUA_MAPPING[escaped] = rhs
				-- TODO HACK figure out why <Cmd> doesn't work in visual mode.
				if mode == "x" or mode == "v" then
					key_mapping = (":<C-u>lua LUA_MAPPING.%s()<CR>"):format(escaped)
				else
					key_mapping = ("<Cmd>lua LUA_MAPPING.%s()<CR>"):format(escaped)
				end
			end
			rhs = key_mapping
			options.noremap = true
			options.silent = true
		end
		if options.buffer then
			options.buffer = nil
			vim.api.nvim_buf_set_keymap(bufnr, mode, mapping, rhs, options)
		else
			vim.api.nvim_set_keymap(mode, mapping, rhs, options)
		end
	end
end

function log(item)
	print(vim.inspect(item))
end

--- Check if a file or directory exists in this path
function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

--- Check if a directory exists in this path
function isdir(path)
	-- "/" works on both Unix and Windows
	return exists(path .. "/")
end

function getPath(str)
	local s = str:gsub("%-", "")
	return s:match("(.*[/\\])")
end

---
-- Higher level text manipulation utilities
---

LUA_MAPPING = {}
LUA_BUFFER_MAPPING = {}

local function escape_keymap(key)
	-- Prepend with a letter so it can be used as a dictionary key
	return "k" .. key:gsub(".", string.byte)
end

function nvim_create_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.api.nvim_command("augroup " .. group_name)
		vim.api.nvim_command("autocmd!")
		for _, def in ipairs(definition) do
			local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
			vim.api.nvim_command(command)
		end
		vim.api.nvim_command("augroup END")
	end
end

---
-- Things Lua should've had
---

function string.startswith(s, n)
	return s:sub(1, #n) == n
end

function string.endswith(self, str)
	return self:sub(-#str) == str
end

---
-- SPAWN UTILS
---
--
function safe_close(handle)
	if not loop.is_closing(handle) then
		loop.close(handle)
	end
end

function spawn(cmd, opts, input, onexit)
	local input = input or { stdout = function() end, stderr = function() end }
	local handle, pid
	local stdout = loop.new_pipe(false)
	local stderr = loop.new_pipe(false)
	handle, pid = loop.spawn(cmd, vim.tbl_extend("force", opts, { stdio = { stdout, stderr } }), function(code, signal)
		if type(onexit) == "function" then
			onexit(code, signal)
		end
		loop.read_stop(stdout)
		loop.read_stop(stderr)
		safe_close(handle)
		safe_close(stdout)
		safe_close(stderr)
	end)
	loop.read_start(stdout, input.stdout)
	loop.read_start(stderr, input.stderr)
end

--- MISC UTILS

-- capturs stdout as a string
function os.capture(cmd, raw)
	local f = assert(io.popen(cmd, "r"))
	local s = assert(f:read("*a"))
	f:close()
	if raw then
		return s
	end
	s = string.gsub(s, "^%s+", "")
	s = string.gsub(s, "%s+$", "")
	s = string.gsub(s, "[\n\r]+", " ")
	return s
end

-- return name of git branch
function gitBranch()
	if is_windows then
		return os.capture("git rev-parse --abbrev-ref HEAD 2> NUL | tr -d '\n'")
	else
		return os.capture("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
	end
end

-- returns short status of changes
function gitStat()
	if is_windows then
		return os.capture("git diff --shortstat 2> NUL | tr -d '\n'")
	else
		return os.capture("git diff --shortstat 2> /dev/null | tr -d '\n'")
	end
end

-- find vim related node_modules
function get_node_bin(bin)
	return fn.stdpath("config") .. "/langservers/node_modules/.bin/" .. bin
end

function iabbrev(src, target, buffer)
	if buffer == nil then
		api.nvim_command("iabbrev " .. src .. " " .. target)
	else
		api.nvim_command("iabbrev <buffer> " .. src .. " " .. target)
	end
end

function augroup(name, commands)
	vim.cmd("augroup " .. name)
	vim.cmd("autocmd!")
	for _, c in ipairs(commands) do
		vim.cmd(
			string.format(
				"autocmd %s %s %s %s",
				table.concat(c.events, ","),
				table.concat(c.targets or {}, ","),
				table.concat(c.modifiers or {}, " "),
				c.command
			)
		)
	end
	vim.cmd("augroup END")
end
