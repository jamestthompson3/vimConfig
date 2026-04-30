local node = require("tt.nvim_utils").nodejs
local constants = require("tt.constants")

local formatters_by_ft = {
	javascript = { "prettier", "biome" },
	javascriptreact = { "prettier", "biome" },
	typescript = { "prettier", "biome" },
	typescriptreact = { "prettier", "biome" },
	go = "gofmt",
	c = "clangfmt",
	cpp = "clangfmt",
	objcpp = "clangfmt",
	css = "prettier",
	scss = { "prettier", "stylint" },
	rust = "rustfmt",
	astro = "prettier",
	html = "prettier",
	json = "prettier",
	lua = "stylua",
	fish = "fish_indent",
	-- yaml = "yamlfmt",
}

local function biomeCheck()
	return vim.fs.root(0, constants.biome_roots)
end

local function prettierCheck()
	return vim.fs.root(0, constants.prettier_roots)
end

-- Build formatters dynamically per-buffer to resolve node binaries relative to the file
local function get_formatters(bufnr)
	bufnr = bufnr or 0
	local prettierBin = node.find_node_executable("prettier", bufnr)
	local biomeBin = node.find_node_executable("biome", bufnr)
	local stylelintBin = node.find_node_executable("stylelint", bufnr)

	return {
		gofmt = { command = { "gofmt", "-s" } },
		prettier = { command = { prettierBin, "--stdin-filepath", "$FILENAME" }, condition = prettierCheck },
		stylint = { command = { stylelintBin, "--fix" } },
		biome = { command = { biomeBin, "format", "--stdin-file-path", "$FILENAME" }, condition = biomeCheck },
		stylua = { command = { "stylua", "-" } },
		rustfmt = { command = { "rustfmt", "$FILENAME", "--emit=stdout", "-q" } },
		clangfmt = { command = { "clang-format", "-assume-filename", "$FILENAME" } },
		yamlfmt = { command = { "yamlfmt", "-in" } },
		fish_indent = { command = { "fish_indent" } },
	}
end

local formatting = false

local function apply_format(bufnr, input, result)
	if result.code ~= 0 then
		vim.notify("Formatter failed: " .. (result.stderr or result.stdout or ""), vim.log.levels.ERROR)
		return
	end
	local output_lines = vim.split(result.stdout, "\n")
	if output_lines[#output_lines] == "" then
		table.remove(output_lines)
	end
	if table.concat(output_lines, "\n") == input then
		return
	end
	local marks = {}
	for _, m in ipairs(vim.fn.getmarklist("%")) do
		local name = m.mark:sub(2)
		if name:match("^%a$") then
			marks[#marks + 1] = { mark = name, pos = m.pos }
		end
	end
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output_lines)
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	for _, m in ipairs(marks) do
		if m.pos[2] <= line_count then
			vim.api.nvim_buf_set_mark(bufnr, m.mark, m.pos[2], m.pos[3], {})
		end
	end
end

local function run_chain(bufnr, filepath, chain, i)
	if i > #chain then
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified then
			formatting = true
			vim.api.nvim_buf_call(bufnr, function()
				vim.cmd.update({ mods = { silent = true } })
			end)
			formatting = false
		end
		return
	end

	local formatter = chain[i]
	local cmd = vim.tbl_map(function(v)
		return v == "$FILENAME" and filepath or v
	end, formatter.command)

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local input = table.concat(lines, "\n")

	vim.system(cmd, { stdin = input }, function(result)
		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end
			apply_format(bufnr, input, result)
			run_chain(bufnr, filepath, chain, i + 1)
		end)
	end)
end

local function format_buffer()
	if formatting or vim.g.autoformat == false then
		return
	end
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo[bufnr].filetype
	local formatterList = formatters_by_ft[filetype]
	if not formatterList then
		return
	end
	local formatters = get_formatters(bufnr)
	local candidates = vim.islist(formatterList) and formatterList or { formatterList }
	local filepath = vim.api.nvim_buf_get_name(bufnr)

	local chain = {}
	for _, name in ipairs(candidates) do
		local f = formatters[name]
		if f and f.command and (f.condition == nil or f.condition()) then
			chain[#chain + 1] = f
		end
	end

	if #chain > 0 then
		run_chain(bufnr, filepath, chain, 1)
	end
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "*" },
	callback = format_buffer,
})

vim.api.nvim_create_user_command("FormatInfo", function()
	local filetype = vim.bo.filetype
	local formatterList = formatters_by_ft[filetype]
	local formatters = get_formatters(0)
	local lines = { "FormatInfo for " .. filetype }

	if not formatterList then
		lines[#lines + 1] = "  No formatters configured"
		vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
		return
	end

	local candidates = vim.islist(formatterList) and formatterList or { formatterList }
	for _, name in ipairs(candidates) do
		local f = formatters[name]
		if not f then
			lines[#lines + 1] = string.format("  ✗ %s (unknown)", name)
		else
			local active = f.condition == nil or f.condition()
			local bin = f.command[1]
			local found = vim.fn.executable(bin) == 1
			local status = active and (found and "✓" or "✗ not found") or "○ skipped"
			lines[#lines + 1] = string.format("  %s %s", status, name)
			lines[#lines + 1] = string.format("      %s", table.concat(f.command, " "))
		end
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, {})
