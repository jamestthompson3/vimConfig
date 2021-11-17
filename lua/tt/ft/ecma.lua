require("tt.nvim_utils")

local fn = vim.fn
local api = vim.api

local M = {}

function M.bootstrap()
	vim.bo.suffixesadd = ".js,.jsx,.ts,.tsx"
	vim.bo.include = "^\\s*[^/]\\+\\(from\\|require(['\"]\\)"
	vim.bo.define = "class\\s"
	vim.wo.foldlevel = 99

	local mappings = {
		["i<C-l>"] = { "console.log()<esc>i", noremap = true, buffer = true },
		["i<C-c>"] = { "console.log('%c%o', 'color: ;')<esc>F%;la", noremap = true, buffer = true },
		["id<C-l>"] = { "debugger", noremap = true, buffer = true },
	}

	nvim_apply_mappings(mappings, { silent = true })
	api.nvim_command([[command! Sort lua require'tt.ft.ecma'.import_sort(true)]])
	api.nvim_command([[command! Eslint lua require'tt.ft.ecma'.linter_d()]])
	api.nvim_command([[command! Lint lua require'tt.ft.ecma'.lint_project()]])
end

local function onread(err, _)
	if err then
		error("IMPORT_SORT: ", err)
	end
end

function M.import_sort(async, cb)
	local path = fn.fnameescape(fn.expand("%:p"))
	local executable_path = find_node_executable("import-sort")

	if fn.executable(executable_path) then
		if true == async then
			spawn(
				executable_path,
				{
					args = { path, "--write" },
				},
				{ stdout = onread, stderr = onread },
				vim.schedule_wrap(function()
					vim.api.nvim_command([["checktime"]])
					if cb ~= nil then
						cb()
					end
				end)
			)
		else
			fn.system(executable_path .. " " .. path .. " " .. "--write")
			vim.api.nvim_command([["checktime"]])
			if cb ~= nil then
				cb()
			end
		end
	else
		error("Cannot find import-sort executable")
	end
end

function M.lint_project()
	local executable_path = find_node_executable("eslint_d")
	local linterResults = {}
	local function readlint(_, data)
		if data then
			table.insert(linterResults, data)
			local vals = vim.split(data, "\n")
			for _, line in pairs(vals) do
				if line and line ~= "" then
					linterResults[#linterResults + 1] = line
				end
			end
		end
	end
	----ext .js,.ts,.tsx --max-warnings=0
	spawn(
		executable_path,
		{
			args = { ".", "--ext", ".js,.ts,.tsx,.jsx", "--max-warnings=0", "-f", "compact", "--fix" },
		},
		{ stdout = readlint, stderr = readlint },
		vim.schedule_wrap(function()
			fn.setloclist(fn.winnr(), {}, " ", {
				title = "eslint -- errors",
				lines = linterResults,
				efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
			})
			api.nvim_command([[lwindow]])
		end)
	)
end

function M.linter_d()
	local path = fn.fnameescape(fn.expand("%:p"))
	local executable_path = find_node_executable("eslint_d")
	local linterResults = {}
	local function readlint(_, data)
		if data then
			table.insert(linterResults, data)
			local vals = vim.split(data, "\n")
			for _, line in pairs(vals) do
				if line and line ~= "" then
					linterResults[#linterResults + 1] = line
				end
			end
		end
	end
	spawn(
		executable_path,
		{
			args = { path, "-f", "compact", "--fix" },
		},
		{ stdout = readlint, stderr = readlint },
		vim.schedule_wrap(function()
			vim.api.nvim_command([["checktime"]])
			fn.setloclist(fn.winnr(), {}, " ", {
				title = "eslint -- errors",
				lines = linterResults,
				efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
			})
			api.nvim_command([[lwindow]])
			vim.lsp.buf_attach_client(0, 1)
		end)
	)
end

function M.sort_and_lint()
	M.import_sort(true, M.linter_d)
end

return M
