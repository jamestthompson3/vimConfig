local M = {}

function M.commands(commands, load)
	local loaded = false
	local function ensure_loaded()
		if loaded then
			return
		end
		for name in pairs(commands) do
			vim.api.nvim_del_user_command(name)
		end
		load()
		loaded = true
	end
	for name, spec in pairs(commands) do
		local opts = vim.tbl_extend("force", {}, spec)
		if opts.nargs and not opts.complete then
			opts.complete = function(_, line, pos)
				ensure_loaded()
				return vim.fn.getcompletion(line:sub(1, pos), "cmdline")
			end
		end
		vim.api.nvim_create_user_command(name, function(args)
			ensure_loaded()
			local cmd = {
				cmd = name,
				args = args.fargs,
				bang = args.bang,
				mods = args.smods,
				-- Arguments have already passed through Ex filename expansion.
				magic = { file = false, bar = false },
			}
			if args.range == 1 then
				cmd.range = { args.line1 }
			elseif args.range == 2 then
				cmd.range = { args.line1, args.line2 }
			end
			vim.api.nvim_cmd(cmd, {})
		end, opts)
	end
	return ensure_loaded
end

return M
