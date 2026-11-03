local node = require("tt.nvim_utils").nodejs
local constants = require("tt.constants")
local M = {}

-- Each stage contains alternatives. Run one formatter per stage.
local web = { { "prettierd", "prettier", "biome" } }
local formatters_by_ft = {
	javascript = web,
	javascriptreact = web,
	typescript = web,
	typescriptreact = web,
	json = { { "prettierd", "prettier", "biome", "jq" } },
	jsonc = web,
	css = { { "prettierd", "prettier" } },
	scss = { { "prettierd", "prettier" }, { "stylelint" } },
	astro = { { "prettierd", "prettier" } },
	html = { { "prettierd", "prettier" } },
	go = { { "gofmt" } },
	rust = { { "rustfmt" } },
	lua = { { "stylua" } },
	c = { { "clangfmt" } },
	cpp = { { "clangfmt" } },
	objc = { { "clangfmt" } },
	objcpp = { { "clangfmt" } },
	fish = { { "fish_indent" } },
}

local function manifest_editions(path)
	local section, package_edition, workspace_edition, inherited = "", nil, nil, false
	for _, line in ipairs(vim.fn.readfile(path)) do
		section = line:match("^%s*%[([^%]]+)%]") or section
		local edition = line:match([=[^%s*edition%s*=%s*["'](%d+)["']]=])
		if section == "package" then
			package_edition = edition or package_edition
			inherited = inherited
				or line:match("^%s*edition%.workspace%s*=%s*true") ~= nil
				or line:match("^%s*edition%s*=%s*{.*workspace%s*=%s*true") ~= nil
		elseif section == "package.edition" then
			inherited = inherited or line:match("^%s*workspace%s*=%s*true") ~= nil
		elseif section == "workspace.package" then
			workspace_edition = edition or workspace_edition
		end
	end
	return package_edition, workspace_edition, inherited
end

local function rust_edition(buf, dir)
	local override = vim.b[buf].rust_edition or vim.g.rust_edition
	if override then
		return tostring(override)
	end
	local manifests = vim.fs.find("Cargo.toml", { path = dir, upward = true, limit = math.huge })
	for i, path in ipairs(manifests) do
		local package_edition, workspace_edition, inherited = manifest_editions(path)
		if i == 1 then
			if package_edition then
				return package_edition
			end
			if not inherited then
				return "2015" -- Cargo uses edition 2015 when package.edition is absent.
			end
		end
		if workspace_edition then
			return workspace_edition
		end
	end
end

local function definitions(buf)
	local file = vim.api.nvim_buf_get_name(buf)
	local dir = node.directory(buf)
	local prettier_root = vim.fs.root(buf, constants.prettier_roots)
	local biome_root = vim.fs.root(buf, constants.biome_roots)
	local function tool(name, cmd, cwd, active)
		return { name = name, cmd = cmd, cwd = cwd or dir, active = active ~= false }
	end
	return {
		prettierd = function()
			return tool(
				"prettierd",
				{ node.find_node_executable("prettierd", buf), file },
				prettier_root,
				prettier_root ~= nil and vim.g.format_prettierd ~= false
			)
		end,
		prettier = function()
			return tool(
				"prettier",
				{ node.find_node_executable("prettier", buf), "--stdin-filepath", file },
				prettier_root,
				prettier_root ~= nil
			)
		end,
		biome = function()
			return tool(
				"biome",
				{ node.find_node_executable("biome", buf), "format", "--stdin-file-path", file },
				biome_root,
				biome_root ~= nil
			)
		end,
		stylelint = function()
			return tool(
				"stylelint",
				{ node.find_node_executable("stylelint", buf), "--fix", "--stdin", "--stdin-filename", file }
			)
		end,
		jq = function()
			return tool("jq", { "jq", "." }, nil, not prettier_root and not biome_root)
		end,
		gofmt = function()
			return tool("gofmt", { "gofmt", "-s" })
		end,
		stylua = function()
			return tool("stylua", { "stylua", "--stdin-filepath", file, "--search-parent-directories", "-" })
		end,
		rustfmt = function()
			local cmd = { "rustfmt", "--emit=stdout", "-q" }
			local config_root = vim.fs.root(buf, { "rustfmt.toml", ".rustfmt.toml" })
			if config_root then
				vim.list_extend(cmd, { "--config-path", config_root })
			end
			local edition = rust_edition(buf, dir)
			if edition then
				vim.list_extend(cmd, { "--edition", edition })
			end
			return tool("rustfmt", cmd)
		end,
		clangfmt = function()
			return tool("clangfmt", { "clang-format", "-assume-filename", file })
		end,
		fish_indent = function()
			return tool("fish_indent", { "fish_indent" })
		end,
	}
end

function M.plan(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local configured = formatters_by_ft[vim.bo[buf].filetype]
	if not configured then
		return {}, {}
	end
	local defs, stages, info = definitions(buf), {}, {}
	for _, alternatives in ipairs(configured) do
		local selected
		for _, name in ipairs(alternatives) do
			local tool = defs[name]()
			local found = tool.cmd[1] ~= "" and vim.fn.executable(tool.cmd[1]) == 1
			local status = not tool.active and "skipped"
				or not found and "not found"
				or selected and "fallback"
				or "selected"
			info[#info + 1] = { tool = tool, status = status }
			if status == "selected" then
				selected = tool
			end
		end
		if selected then
			stages[#stages + 1] = selected
		end
	end
	return stages, info
end

local function output_lines(output)
	local lines = vim.split(output, "\n", { plain = true })
	if lines[#lines] == "" then
		table.remove(lines)
	end
	return #lines > 0 and lines or { "" }
end

local function apply_format(buf, input, lines)
	local output = table.concat(lines, "\n")
	if output == input then
		return
	end
	local hunks = vim.text.diff(input .. "\n", output .. "\n", { result_type = "indices" })
	for i = #hunks, 1, -1 do
		local start_a, count_a, start_b, count_b = unpack(hunks[i])
		local first = count_a == 0 and start_a or start_a - 1
		vim.api.nvim_buf_set_lines(
			buf,
			first,
			first + count_a,
			false,
			vim.list_slice(lines, start_b, start_b + count_b - 1)
		)
	end
end

local function run_formatter(tool, input, timeout)
	local ok, result = pcall(function()
		return vim.system(tool.cmd, { stdin = input, text = true, cwd = tool.cwd }):wait(timeout)
	end)
	if not ok then
		return nil, tostring(result)
	end
	if result.code ~= 0 then
		local err = result.code == 124 and "timed out" or vim.trim(result.stderr or "")
		return nil, err
	end
	return result.stdout or ""
end

-- wait() processes events, so buffer edits can occur before it returns.
function M.format(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local enabled = vim.b[buf].autoformat
	if enabled == nil then
		enabled = vim.g.autoformat
	end
	if enabled == false or vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then
		return true
	end
	local plan = M.plan(buf)
	if #plan == 0 then
		return true
	end
	local tick = vim.api.nvim_buf_get_changedtick(buf)
	local input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
	local output = input .. "\n"
	local timeout = vim.b[buf].format_timeout_ms or vim.g.format_timeout_ms or 2000
	for _, tool in ipairs(plan) do
		local formatted, err = run_formatter(tool, output, timeout)
		if err then
			return false, ("%s: %s (save cancelled; buffer unchanged)"):format(tool.name, err)
		end
		output = formatted
	end
	if not vim.api.nvim_buf_is_valid(buf) or vim.api.nvim_buf_get_changedtick(buf) ~= tick then
		return false, "Buffer changed during formatting; save cancelled"
	end
	apply_format(buf, input, output_lines(output))
	return true
end

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("tt_format", { clear = true }),
	callback = function(ev)
		local ok, err = M.format(ev.buf)
		if not ok then
			error(err, 0)
		end
	end,
})

vim.api.nvim_create_user_command("FormatInfo", function()
	local _, info = M.plan(vim.api.nvim_get_current_buf())
	local lines = { "FormatInfo for " .. vim.bo.filetype }
	for _, entry in ipairs(info) do
		lines[#lines + 1] = ("  %s: %s\n    %s\n    cwd: %s"):format(
			entry.tool.name,
			entry.status,
			table.concat(entry.tool.cmd, " "),
			entry.tool.cwd
		)
	end
	if #info == 0 then
		lines[#lines + 1] = "  No formatters configured"
	end
	vim.notify(table.concat(lines, "\n"))
end, {})

return M
