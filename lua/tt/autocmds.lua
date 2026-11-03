local load_core = vim.api.nvim_create_augroup("load_core", { clear = true })
local bufs = vim.api.nvim_create_augroup("bufs", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = load_core,
	callback = function()
		require("tt.tools").openQuickfix()
		local proj = require("tt.project")
		proj.setup()
		proj.add_current_project()
	end,
})

vim.api.nvim_create_autocmd({ "TextYankPost", "TextPutPost" }, {
	group = load_core,
	callback = function()
		vim.hl.hl_op({ timeout = 100 })
	end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
	group = load_core,
	pattern = "*.html",
	command = "0r ~/vim/skeletons/skeleton.html",
})

vim.api.nvim_create_autocmd("BufNewFile", {
	group = load_core,
	pattern = "*.md",
	command = "0r ~/vim/skeletons/skeleton.md",
})

vim.api.nvim_create_autocmd("BufWriteCmd", {
	group = bufs,
	pattern = "*.todo",
	callback = function(ev)
		require("tt.todo").submit(ev.buf)
	end,
})

vim.api.nvim_create_autocmd("VimResized", {
	desc = "Automatically resize splits, when terminal window is moved",
	command = "wincmd =",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = load_core,
	callback = require("tt.tools").saveSession,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = load_core,
	pattern = "[^l]*",
	nested = true,
	callback = require("tt.tools").openQuickfix,
})

vim.api.nvim_create_autocmd("TermClose", {
	group = bufs,
	callback = function(ev)
		if vim.v.event.status == 0 then
			vim.api.nvim_buf_delete(ev.buf, { force = true })
		end
	end,
})

vim.api.nvim_create_autocmd("TermRequest", {
	group = load_core,
	callback = function(ev)
		if string.match(ev.data.sequence, "^\027]133;A") then
			-- OSC 133 A marks a shell prompt.
			local lnum = ev.data.cursor[1]
			vim.api.nvim_buf_set_extmark(ev.buf, vim.api.nvim_create_namespace("my.terminal.prompt"), lnum - 1, 0, {
				sign_text = "∙",
			})
		end

		local title = ev.data.sequence:match("^\027%][02];(.-)\007") or ev.data.sequence:match("^\027%][02];(.-)\027\\")
		if title then
			vim.b[ev.buf].term_title = title
		end

		local val, n = string.gsub(ev.data.sequence, "^\027]7;file://[^/]*", "")
		if n > 0 then
			-- OSC 7 reports the current directory.
			local dir = val
			if vim.fn.isdirectory(dir) == 0 then
				vim.notify("invalid dir: " .. dir)
				return
			end
			vim.b[ev.buf].osc7_dir = dir
			if vim.api.nvim_get_current_buf() == ev.buf then
				vim.cmd.bcd(dir)
			end
		end
	end,
})
