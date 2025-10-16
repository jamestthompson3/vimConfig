local git = require("tt.git")

local load_core = vim.api.nvim_create_augroup("load_core", { clear = true })
local bufs = vim.api.nvim_create_augroup("bufs", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = load_core,
	callback = function()
		require("tt.tools").openQuickfix()
		-- UI stuff
		vim.cmd("hi link TreesitterContext Pmenu")
		vim.cmd("hi link DiagnosticUnnecessary WildMenu")

		if vim.o.background == "dark" then
			vim.cmd("hi Comment guifg=#0c2919 guibg=#a8d4c3")
			vim.cmd("hi Pmenu guifg=#1a1a5a guibg=#d0d5e0")
			vim.cmd("hi PmenuSel guifg=#0c2919 guibg=#a8d4c3")
			vim.cmd("hi PmenuMatch gui=bold guifg=#8b0000 guibg=NONE")
			vim.cmd("hi PmenuMatchSel gui=bold guifg=#8b0000 guibg=NONE")
			vim.cmd("hi StatusLine guifg=#0c2919 guibg=#a8d4c3")
			vim.cmd("hi Cursor gui=none guifg=#000000 guibg=#ff5f00")
			vim.cmd("hi @markup.raw guibg=NONE")
			vim.cmd("hi link @commment.block Pmenu")
		else
			vim.cmd("hi Comment guifg=#0a1a4a guibg=#c8d8f0")
			vim.cmd("hi Pmenu guifg=#1a1a1a guibg=#e8e8e8")
			vim.cmd("hi PmenuSel guifg=#0a1a4a guibg=#c8d8f0")
			vim.cmd("hi PmenuMatchSel guifg=#8b0000 guibg=NONE gui=bold")
			vim.cmd("hi LineNr guifg=#4f4f4f")
			vim.cmd("hi Cursor gui=none guifg=#3a3a00 guibg=#dab862")
			vim.cmd("hi DiagnosticHint guifg=#0c2919 guibg=#c8e8d8")
			vim.cmd("hi DiagnosticUnderlineHint guisp=#0c2919")
			vim.cmd("hi @comment.note guifg=#0a3a3a guibg=#c8e8e8")
			vim.cmd("hi link @commment.block Pmenu")
		end
	end,
})

vim.api.nvim_create_autocmd("SwapExists", {
	group = load_core,
	command = "call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = load_core,
	callback = function()
		vim.highlight.on_yank({ higroup = "Search", timeout = 100 })
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

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = load_core,
	callback = require("tt.tools").saveSession,
})

vim.api.nvim_create_autocmd("VimResume", {
	group = load_core,
	command = "checktime",
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	group = load_core,
	pattern = "[^l]*",
	nested = true,
	callback = require("tt.tools").openQuickfix,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	group = load_core,
	callback = function()
		git.clear_blame()
	end,
})

vim.api.nvim_create_autocmd("FocusGained", {
	group = load_core,
	command = "checktime",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = bufs,
	pattern = "quickfix",
	callback = function()
		vim.keymap.set("n", "ra", ":ReplaceAll<CR>", { buffer = true, silent = true })
		vim.keymap.set("n", "R", ":Cfilter!<space>", { buffer = true })
		vim.keymap.set("n", "K", ":Cfilter<space>", { buffer = true })
	end,
})
