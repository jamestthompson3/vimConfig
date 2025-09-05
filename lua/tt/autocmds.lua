local git = require("tt.git")

local load_core = vim.api.nvim_create_augroup("load_core", { clear = true })
local bufs = vim.api.nvim_create_augroup("bufs", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
	group = load_core,
	callback = require("tt.tools").openQuickfix,
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
