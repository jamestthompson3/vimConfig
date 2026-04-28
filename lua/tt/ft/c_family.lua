local M = {}

function M.bootstrap(opts)
	vim.b.source_ft = opts.source_ft

	vim.opt_local.formatoptions:remove({ "r", "o" })
	vim.bo.define = "^(#s*define|[a-z]*s*consts*[a-z]*)"

	vim.keymap.set("n", "<leader>h", function()
		require("tt.tools").switchSourceHeader()
	end, { buffer = true, silent = true })

	if opts.efm ~= false then
		require("tt.lsp.efm").init()
		vim.lsp.start(vim.lsp.config.efm)
	end

	if opts.extra_path then
		vim.o.path = vim.o.path .. opts.extra_path
	end

	local ext = vim.fn.expand("%:e")
	local header_exts = opts.header_exts or { "h" }
	local use_pragma = opts.pragma_once == true or (opts.pragma_once == nil and ext ~= "h")
	if vim.tbl_contains(header_exts, ext) and vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
		if use_pragma then
			vim.api.nvim_buf_set_lines(0, 0, 0, false, {
				"#pragma once",
				"",
				"",
			})
			vim.api.nvim_win_set_cursor(0, { 3, 0 })
		else
			local guard = vim.fn.expand("%:t"):upper():gsub("[^%w]", "_")
			vim.api.nvim_buf_set_lines(0, 0, 0, false, {
				"#ifndef " .. guard,
				"#define " .. guard,
				"",
				"",
				"#endif",
			})
			vim.api.nvim_win_set_cursor(0, { 4, 0 })
		end
	end
end

return M
