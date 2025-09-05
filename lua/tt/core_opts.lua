local iabbrev = require("tt.nvim_utils").vim_util.iabbrev
local api = vim.api

if not is_windows then
	vim.o.shell = vim.fn.executable("fish") and "fish" or "bash"
end

vim.cmd.packadd("cfilter")

-- Common mistakes
iabbrev("retrun", "return")
iabbrev("pritn", "print")
iabbrev("cosnt", "const")
iabbrev("imoprt", "import")
iabbrev("imprt", "import")
iabbrev("iomprt", "import")
iabbrev("improt", "import")
iabbrev("slef", "self")
iabbrev("sapn", "span")
iabbrev("teh", "the")
iabbrev("tehn", "then")
iabbrev("hadnler", "handler")
iabbrev("bunlde", "bundle")

vim.api.nvim_create_user_command("Diff", function()
	require("tt.git").diff()
end, {})

vim.api.nvim_create_user_command("Changed", function()
	require("tt.git").changedFiles()
end, {})

vim.api.nvim_create_user_command("Restore", function()
	require("tt.tools").restoreFile()
end, {})

vim.api.nvim_create_user_command("Redir", function(opts)
	vim.cmd('silent call tools#redir("' .. opts.args .. '")')
end, { nargs = 1, complete = "command" })

-- Global Vim functions
vim.api.nvim_exec2(
	[[
function! AS_HandleSwapfile(filename, swapname)
    " if swapfile is older than file itself, just get rid of it
    if getftime(v:swapname) < getftime(a:filename)
        call delete(v:swapname)
        let v:swapchoice = 'e'
    endif
endfunction
]],
	{ output = false }
)
