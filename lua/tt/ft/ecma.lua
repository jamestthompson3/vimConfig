local node = require("tt.nvim_utils").nodejs
local constants = require("tt.constants")

local fn = vim.fn

local M = {}

function M.bootstrap()
	if vim.bo.readonly ~= true then
		require("tt.snippets.ft.ecmascript").init()
	end
	vim.bo.suffixesadd = ".js,.jsx,.ts,.tsx"
	vim.bo.include = "^\\s*[^/]\\+\\(from\\|require(['\"]\\)"
	vim.bo.define = "class\\s"
	vim.wo.foldlevel = 99

	vim.api.nvim_create_user_command("Sort", function()
		require("tt.ft.ecma").import_sort(true)
	end, {})
	vim.api.nvim_create_user_command("Eslint", function()
		require("tt.ft.ecma").linter_d()
	end, {})
	vim.api.nvim_create_user_command("Lint", function()
		require("tt.ft.ecma").lint_project()
	end, {})

	-- optionally enable formatters/linters
	if vim.fs.root(0, constants.eslint_roots) then
		require("tt.lsp.efm").init()
		vim.lsp.start(vim.lsp.config.efm)
	end

	if vim.fs.root(0, constants.prettier_roots) then
		vim.b.autoformat = true
	end
end

function M.import_sort(async, cb)
	local path = fn.fnameescape(fn.expand("%:p"))
	local executable_path = node.find_node_executable("import-sort")

	if fn.executable(executable_path) ~= 1 then
		vim.notify("Cannot find import-sort executable", vim.log.levels.ERROR)
		return
	end

	if async then
		vim.system({ executable_path, path, "--write" }, { text = true }, function(result)
			vim.schedule(function()
				if result.code == 0 then
					vim.cmd.checktime()
					if cb then
						cb()
					end
				else
					vim.notify("IMPORT_SORT: " .. (result.stderr or ""), vim.log.levels.ERROR)
				end
			end)
		end)
	else
		vim.system({ executable_path, path, "--write" }):wait()
		vim.cmd.checktime()
		if cb then
			cb()
		end
	end
end

function M.lint_project()
	local executable_path = node.find_node_executable("eslint_d")

	vim.system({
		executable_path,
		".",
		"--ext",
		".js,.ts,.tsx,.jsx",
		"--max-warnings=0",
		"-f",
		"compact",
		"--fix",
	}, { text = true }, function(result)
		vim.schedule(function()
			local lines = {}
			if result.stdout then
				lines = vim.split(result.stdout, "\n", { trimempty = true })
			end
			fn.setloclist(fn.winnr(), {}, " ", {
				title = "eslint -- errors",
				lines = lines,
				efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
			})
			vim.cmd.lwindow()
		end)
	end)
end

function M.linter_d()
	local path = fn.fnameescape(fn.expand("%:p"))
	local executable_path = node.find_node_executable("eslint_d")

	vim.system({
		executable_path,
		path,
		"-f",
		"compact",
		"--fix",
	}, { text = true }, function(result)
		vim.schedule(function()
			vim.cmd.checktime()
			local lines = {}
			if result.stdout then
				lines = vim.split(result.stdout, "\n", { trimempty = true })
			end
			fn.setloclist(fn.winnr(), {}, " ", {
				title = "eslint -- errors",
				lines = lines,
				efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
			})
			vim.cmd.lwindow()
		end)
	end)
end

return M
