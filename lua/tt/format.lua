local node = require("tt.nvim_utils").nodejs
local constants = require("tt.constants")

local prettierBin
local biomeBin
local formatters

local formatters_by_ft = {
	javascript = { "prettier", "biome" },
	javascriptreact = { "prettier", "biome" },
	typescript = { "prettier_ts", "biome" },
	typescriptreact = { "prettier_ts", "biome" },
	go = "gofmt",
	c = "clangfmt",
	cpp = "clangfmt",
	objcpp = "clangfmt",
	css = "prettier_css",
	scss = { "prettier_css", "stylint" },
	rust = "rustfmt",
	astro = "prettier_astro",
	html = "prettier_html",
	json = "prettier_json",
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

local function setup_formatters()
	if formatters then
		return
	end

	prettierBin = node.find_node_executable("prettier")
	biomeBin = node.find_node_executable("biome")

	local function makePrettierFormatter(parser)
		return { command = { prettierBin, "--parser", parser }, condition = prettierCheck }
	end

	formatters = {
		-- remove_whitepsace = {
		-- 	exec = function()
		-- 		if 1 == vim.g.remove_whitespace then
		-- 			vim.nvim_exec("normal mz", false)
		-- 			vim.cmd("%s/\\s\\+$//ge")
		-- 			vim.nvim_exec("normal `z", false)
		-- 		end
		-- 	end,
		-- },
		gofmt = { command = { "gofmt", "-s" } },
		prettier = { command = { prettierBin }, condition = prettierCheck },
		prettier_ts = makePrettierFormatter("typescript"),
		stylint = { command = { node.find_node_executable("stylelint"), "--fix" } },
		biome = { command = { biomeBin, "format" }, condition = biomeCheck },
		prettier_json = makePrettierFormatter("json"),
		prettier_html = makePrettierFormatter("html"),
		prettier_css = makePrettierFormatter("css"),
		prettier_astro = { command = { prettierBin, "--stdin-filepath", "$FILENAME" }, condition = prettierCheck },
		stylua = {
			command = { "stylua", "-" },
		},
		rustfmt = {
			command = { "rustfmt", "$FILENAME", "--emit=stdout", "-q" },
		},
		clangfmt = { command = { "clang-format", "-assume-filename", "$FILENAME" } },
		yamlfmt = { command = { "yamlfmt", "-in" } },
		fish_indent = { command = { "fish_indent" } },
	}
end

local function runFormat(buf, formatter)
	if vim.g.autoformat == false then
		return
	end
	local cmd = formatter.command
	if not cmd then
		return
	end

	local input = ""
	if vim.tbl_contains(cmd, "$FILENAME") then
		cmd = vim.tbl_map(function(v)
			if v == "$FILENAME" then
				return buf
			end
			return v
		end, cmd)
	end
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	input = table.concat(lines, "\n")

	local result = vim.system(cmd, { stdin = input }):wait()
	local exit_code = result.code

	if exit_code == 0 then
		local output_lines = vim.split(result.stdout, "\n")
		-- Remove trailing empty line if present
		if output_lines[#output_lines] == "" then
			table.remove(output_lines)
		end
		vim.api.nvim_buf_set_lines(0, 0, -1, false, output_lines)
	else
		vim.notify("Formatter failed: " .. (result.stderr or result.stdout or ""), vim.log.levels.ERROR)
	end
end

-- Format function
local function format_buffer()
	setup_formatters()
	local filetype = vim.bo.filetype
	local formatterList = formatters_by_ft[filetype]

	local buf = vim.api.nvim_buf_get_name(0)
	if vim.islist(formatterList) then
		for _, formatter in pairs(formatterList) do
			local f = formatters[formatter]
			if f.condition ~= nil then
				if f.condition() then
					runFormat(buf, f)
				end
			else
				runFormat(buf, f)
			end
		end
	end
	if not formatters[formatterList] then
		return
	end
	runFormat(buf, formatters[formatterList])
end

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	callback = format_buffer,
})

vim.api.nvim_create_user_command("FormatInfo", function()
	setup_formatters()
	local filetype = vim.bo.filetype
	local formatterList = formatters_by_ft[filetype]
	local formattersToRun = {}

	if vim.islist(formatterList) then
		for _, formatter in pairs(formatterList) do
			local f = formatters[formatter]
			if f.condition ~= nil then
				if f.condition() then
					table.insert(formattersToRun, formatter)
				end
			end
		end
		log("Running > " .. vim.iter(formattersToRun):join(","))
		for _, formatter in pairs(formattersToRun) do
			local f = formatters[formatter]
			log("   Command: " .. vim.iter(f.command):join(" "))
		end
		return
	end
	if not formatters[formatterList] then
		log("No formatters found with: " .. formatterList)
		return
	else
		table.insert(formattersToRun, formatterList)
	end
	log("Running > " .. vim.iter(formattersToRun):join(","))
	for _, formatter in pairs(formattersToRun) do
		local f = formatters[formatter]
		log("   Command: " .. vim.iter(f.command):join(" "))
	end
end, {})
