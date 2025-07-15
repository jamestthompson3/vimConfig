local utils = require("tt.nvim_utils")
local create_augroups = utils.vim_util.create_augroups
local node = utils.nodejs
local keys = utils.keys
local buf_nnoremap = keys.buf_nnoremap
local git = require("tt.git")

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
		{
			"BufWritePost",
			{
				pattern = "*.fish",
				callback = function()
					vim.fn.jobstart({ "fish_indent", "-w", vim.fn.expand("%") }, {
						stdout_buffered = true,
						stderr_buffered = true,
						on_exit = function(_, code)
							if code == 0 then
								vim.cmd("checktime")
							end
						end,
					})
				end,
			},
		},
		{
			"BufWritePost",
			{
				pattern = "*.eta",
				callback = function()
					local path = fn.fnameescape(fn.expand("%:p"))
					local exec_path = node.find_node_executable("prettier")
					if fn.executable(exec_path) then
						vim.fn.jobstart({ exec_path, path, "--parser", "html", "--write" }, {
							stdout_buffered = true,
							stderr_buffered = true,
							on_exit = function(_, code)
								if code == 0 then
									vim.cmd("checktime")
								end
							end,
						})
					end
				end,
			},
		},

		{ "QuickFixCmdPost", { pattern = "[^l]*", nested = true, callback = require("tt.tools").openQuickfix } },
		{ { "CursorMoved", "CursorMovedI" }, {
			callback = function()
				git.clear_blame()
			end,
		} },
		{ { "FocusGained" }, { command = "checktime" } },
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
					buf_nnoremap({ "R", ":Cfilter!<space>" })
					buf_nnoremap({ "K", ":Cfilter<space>" })
				end,
			},
		},
	},
}
create_augroups(autocmds)
