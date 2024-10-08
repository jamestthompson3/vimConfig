local utils = require("tt.nvim_utils")
local create_augroups = utils.vim_util.create_augroups
local node = utils.nodejs
local keys = utils.keys
local nnore = keys.nmap
local buf_nnoremap = keys.buf_nnoremap
local git = require("tt.git")

local au = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup
local fn = vim.fn

local autocmds = {
	load_core = {
		{ "VimEnter", { callback = require("tt.tools").openQuickfix } },
		{ "SwapExists", { command = "call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)" } },
		{
			"TextYankPost",
			{
				callback = function()
					require("vim.highlight").on_yank({ higroup = "Search", timeout = 100 })
				end,
			},
		},
		{ "BufNewFile", { pattern = "*.html", command = "0r ~/vim/skeletons/skeleton.html" } },
		{ "BufNewFile", { pattern = "*.md", command = "0r ~/vim/skeletons/skeleton.md" } },
		{ "VimLeavePre", { callback = require("tt.tools").saveSession } },
		{ "VimResume", { command = "checktime" } },
		{ "TermOpen", {
			callback = function()
				vim.wo.relativenumber = false
        vim.wo.number = false
			end,
		} },
		{
			"BufWritePre",
			{ command = "if !isdirectory(expand('<afile>:p:h'))|call mkdir(expand('<afile>:p:h'), 'p')|endif" },
		},
		{ "BufWritePre", { callback = require("tt.tools").removeWhitespace } },
		-- TODO: ASYNC
		{ "BufWritePost", { pattern = "*.fish", command = "silent !fish_indent -w %" } },
		-- {
		-- 	"BufWritePost",
		-- 	{
		-- 		pattern = "*.eta",
		-- 		callback = function()
		-- 			local path = fn.fnameescape(fn.expand("%:p"))
		-- 			local exec_path = node.find_node_executable("prettier")
		-- 			if fn.executable(exec_path) then
		-- 				fn.system(exec_path .. " " .. path .. " --parser html " .. "--write")
		-- 				vim.api.nvim_command([["checktime"]])
		-- 			end
		-- 		end,
		-- 	},
		-- },

		{ "QuickFixCmdPost", { pattern = "[^l]*", nested = true, callback = require("tt.tools").openQuickfix } },
		{ "CursorMoved", {
			callback = function()
				git.clear_blame()
			end,
		} },
		{ "CursorMovedI", {
			callback = function()
				git.clear_blame()
			end,
		} },
		{ { "FocusGained", "CursorMoved", "CursorMovedI" }, { command = "checktime" } },
	},
	ft = {
		{ "FileType", { pattern = "netrw", command = "au BufLeave netrw close" } },
		{
			"FileType",
			{
				pattern = "dirvish",
				callback = function()
					buf_nnoremap({ "D", require("tt.tools").deleteFile, { silent = true } })
					buf_nnoremap({ "r", require("tt.tools").renameFile })
					buf_nnoremap({ "<leader>n", ":e %" })
				end,
			},
		},
		{
			"FileType",
			{
				pattern = "netrw",
				callback = function()
					buf_nnoremap({ "q", ":close<CR>" })
				end,
			},
		},
	},
	bufs = {
		{
			"BufReadPost",
			{
				pattern = "quickfix",
				callback = function()
					buf_nnoremap({ "ra", ":ReplaceAll<CR>", { silent = true } })
				end,
			},
		},
		{
			"BufReadPost",
			{
				pattern = "quickfix",
				callback = function()
					buf_nnoremap({ "R", ":Cfilter!<space>" })
				end,
			},
		},
		{
			"BufReadPost",
			{
				pattern = "quickfix",
				callback = function()
					buf_nnoremap({ "K", ":Cfilter<space>" })
				end,
			},
		},
		{ "BufReadPost", { pattern = "*.fugitiveblame", command = "set ft=fugitiveblame" } },
	},
	ft_detect = {
		{ { "BufRead", "BufNewFile" }, { pattern = "*.nginx", command = "set ft=nginx" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "nginx*.conf", command = "set ft=nginx" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "*nginx.conf", command = "set ft=nginx" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "*/etc/nginx/*", command = "set ft=nginx" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "*/usr/local/nginx/conf/*", command = "set ft=nginx" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "*/nginx/*.conf", command = "set ft=nginx" } },
		{ { "BufNewFile", "BufRead" }, { pattern = "*.bat,*.sys", command = "set ft=dosbatch" } },
		{ { "BufNewFile", "BufRead" }, { pattern = "*.mm,*.m", command = "set ft=objc" } },
		{ { "BufNewFile", "BufRead" }, { pattern = "*.h,*.m,*.mm", command = "set tags+=~/global-objc-tags" } },
		{ { "BufNewFile", "BufRead" }, { pattern = "*.tsx", command = "setlocal commentstring=//%s" } },
		{ { "BufNewFile", "BufRead" }, { pattern = "*.svelte", command = "setfiletype html" } },
		{
			{ "BufRead", "BufNewFile" },
			{
				pattern = "*.eslintrc,*.babelrc,*.prettierrc,*.huskyrc,*.swcrc,.swcrc,.eslintrc,.babelrc,.prettierrc",
				command = "set ft=json",
			},
		},
		{ { "BufNewFile", "BufRead" }, { pattern = "*.pcss", command = "set ft=css" } },
		{ { "BufNewFile", "BufRead" }, { pattern = "*.wiki", command = "set ft=wiki" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "[Dd]ockerfile", command = "set ft=Dockerfile" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "Dockerfile*", command = "set ft=Dockerfile" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "[Dd]ockerfile.vim", command = "set ft=vim" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "*.dock", command = "set ft=Dockerfile" } },
		{ { "BufRead", "BufNewFile" }, { pattern = "*.[Dd]ockerfile", command = "set ft=Dockerfile" } },
	},
}
create_augroups(autocmds)
