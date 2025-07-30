local node = require("tt.nvim_utils").nodejs

local prettierBin
local formatters

local formatters_by_ft = {
	javascript = "prettier",
	javascriptreact = "prettier",
	typescript = "prettier",
	g = "gofmt",
	c = "clangfmt",
	cpp = "clangfmt",
	objcpp = "clangfmt",
	css = "prettier_css",
	scss = "prettier_css",
	rust = "rustfmt",
	astro = "prettier_astro",
	typescriptreact = "prettier",
	html = "prettier_html",
	json = "prettier_json",
	lua = "stylua",
}

local function setup_formatters()
	if formatters then
		return
	end

	prettierBin = node.find_node_executable("prettier")

	local function makePrettierFormatter(parser)
		return { prettierBin, "--stdin-filepath", "$FILENAME", "--parser", parser }
	end

	formatters = {
		prettier = { command = { prettierBin, "--stdin-filepath", "$FILENAME" } },
		prettier_json = { command = makePrettierFormatter("json") },
		prettier_html = { command = makePrettierFormatter("html") },
		stylua = {
			command = { "stylua", "--stdin-filepath", "$FILENAME", "-" },
		},
		rustfmt = {
			command = { "rustfmt", "$FILENAME", "--emit=stdout", "-q" },
		},
		clangfmt = { command = { "clang-format" } },
		prettier_css = { command = makePrettierFormatter("css") },
	}
end

-- Format function
local function format_buffer()
	setup_formatters()
	local filetype = vim.bo.filetype
	local formatter = formatters_by_ft[filetype]

	local buf = vim.api.nvim_buf_get_name(0)
	if not formatters[formatter] then
		return
	end
	local cmd = formatters[formatter].command
	if not cmd then
		return
	end

	if vim.tbl_contains(cmd, "$FILENAME") then
		cmd = vim.tbl_map(function(v)
			if v == "$FILENAME" then
				return buf
			end
			return v
		end, cmd)
	else
		table.insert(cmd, buf)
	end

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local input = table.concat(lines, "\n")

	local result = vim.fn.system(cmd, input)
	local exit_code = vim.v.shell_error

	if exit_code == 0 then
		local output_lines = vim.split(result, "\n")
		-- Remove trailing empty line if present
		if output_lines[#output_lines] == "" then
			table.remove(output_lines)
		end
		vim.api.nvim_buf_set_lines(0, 0, -1, false, output_lines)
	else
		vim.notify("Formatter failed: " .. result, vim.log.levels.ERROR)
	end
end

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	callback = format_buffer,
})

-- Manual format command
vim.api.nvim_create_user_command("Format", format_buffer, {})
