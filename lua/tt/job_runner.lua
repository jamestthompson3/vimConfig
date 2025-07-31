local M = {}

function M.run_job(cmd, opts)
	opts = opts or {}
	
	local results = {}
	local default_opts = {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if #data > 0 and data[1] ~= "" then
				for _, line in ipairs(data) do
					if line ~= "" then
						if opts.collect_output then
							table.insert(results, line)
						elseif opts.on_stdout then
							opts.on_stdout(line)
						else
							vim.schedule(function()
								print(line)
							end)
						end
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if #data > 0 and data[1] ~= "" then
				for _, line in ipairs(data) do
					if line ~= "" then
						if opts.collect_output then
							table.insert(results, line)
						elseif opts.on_stderr then
							opts.on_stderr(line)
						else
							vim.schedule(function()
								error(line)
							end)
						end
					end
				end
			end
		end,
		on_exit = function(_, code)
			if opts.on_exit then
				opts.on_exit(code, results)
			end
		end,
	}
	
	local job_opts = vim.tbl_extend("force", default_opts, opts)
	return vim.fn.jobstart(cmd, job_opts)
end

return M