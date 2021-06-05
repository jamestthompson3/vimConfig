local M = {}

local loop = vim.loop

local function make_debug(prefix, debug_fn)
	if debug_fn == nil then
		return function()
		end
	end

	return function(data)
		for _, line in ipairs(vim.split(data, "\n")) do
			if line ~= "" then
				debug_fn(string.format("%s: %s", prefix, line))
			end
		end
	end
end

local function input_collector(prefix, debug_fn)
	local debug = make_debug(prefix, debug_fn)
	local result = { data = "" }
	function result.callback(err, chunk)
		if err then
			result.err = err
		elseif chunk then
			result.data = result.data .. chunk
			debug(chunk)
		end
	end
	return result
end

local function safe_close(h, cb)
	if not loop.is_closing(h) then
		loop.close(h, cb)
	end
end

-- run takes the given command, args and input_data (used as stdin for the
-- child process).
--
-- The last parameter is a callback that will be invoked whenever the command
-- finishes, the callback receives a table in the following shape:
--
-- {
--   stdout: string;
--   stderr: string;
--   exit_status: number;
--   signal: number;
--   errors: string table;
-- }
--
-- The function returns a function that can be called to wait for the command
-- to finish. The function takes a timeout and returns the same values as
-- vim.wait.
function M.run(cmd, opts, input_data, on_finished, debug_fn)
	local cmd_handle
	local stdout = loop.new_pipe(false)
	local stderr = loop.new_pipe(false)
	local stdin = loop.new_pipe(false)

	local function close()
		loop.read_stop(stdout)
		loop.read_stop(stderr)
		safe_close(stdout)
		safe_close(stderr)
		safe_close(stdin)
		safe_close(cmd_handle)
	end

	local stdout_handler = input_collector("STDOUT", debug_fn)
	local stderr_handler = input_collector("STDERR", debug_fn)

	local r = { abort = false, finished = false }
	local function onexit(code, signal)
		if r.abort and code == 0 then
			code = -1
		end
		vim.schedule(function()
			local errors = {}
			if stdout_handler.err then
				table.insert(errors, stdout_handler.err)
			end
			if stderr_handler.err then
				table.insert(errors, stderr_handler.err)
			end

			on_finished({
				exit_status = code,
				aborted = r.abort,
				signal = signal,
				stdout = stdout_handler.data,
				stderr = stderr_handler.data,
				errors = errors,
			})
			r.finished = true
			close()
		end)
	end

	local pid_or_err
	opts = vim.tbl_extend("error", opts, { stdio = { stdin, stdout, stderr } })
	cmd_handle, pid_or_err = loop.spawn(cmd, opts, onexit)

	if not cmd_handle then
		vim.schedule(function()
			on_finished({ exit_status = -1, stderr = pid_or_err })
		end)
		return
	end

	loop.read_start(stdout, stdout_handler.callback)
	loop.read_start(stderr, stderr_handler.callback)

	if input_data then
		loop.write(stdin, input_data)
	end
	loop.shutdown(stdin)

	return function(timeout_ms)
		local status, code = vim.wait(timeout_ms, function()
			return r.finished
		end, 20)

		if not status then
			r.abort = true
			safe_close(cmd_handle, close)
		end

		return status, code
	end
end

return M
