local node = require("tt.nvim_utils").nodejs
local constants = require("tt.constants")
local job_runner = require("tt.job_runner")

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

	if fn.executable(executable_path) then
		if true == async then
			job_runner.run_job({
				executable_path,
				path,
				"--write",
			}, {
				on_stdout = function(line)
					vim.schedule(function()
						print(line)
					end)
				end,
				on_stderr = function(line)
					vim.schedule(function()
						error("IMPORT_SORT: " .. line)
					end)
				end,
				on_exit = function(code)
					if code == 0 then
						vim.schedule(function()
							vim.cmd.checktime()
							if cb ~= nil then
								cb()
							end
						end)
					end
				end,
			})
		else
			vim.system({ executable_path, path, "--write" }):wait()
			vim.cmd.checktime()
			if cb ~= nil then
				cb()
			end
		end
	else
		error("Cannot find import-sort executable")
	end
end

function M.lint_project()
	local executable_path = node.find_node_executable("eslint_d")

	job_runner.run_job({
		executable_path,
		".",
		"--ext",
		".js,.ts,.tsx,.jsx",
		"--max-warnings=0",
		"-f",
		"compact",
		"--fix",
	}, {
		collect_output = true,
		on_exit = function(_, results)
			vim.schedule(function()
				fn.setloclist(fn.winnr(), {}, " ", {
					title = "eslint -- errors",
					lines = results,
					efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
				})
				vim.cmd.lwindow()
			end)
		end,
	})
end

function M.linter_d()
	local path = fn.fnameescape(fn.expand("%:p"))
	local executable_path = node.find_node_executable("eslint_d")

	job_runner.run_job({
		executable_path,
		path,
		"-f",
		"compact",
		"--fix",
	}, {
		collect_output = true,
		on_exit = function(_, results)
			vim.schedule(function()
				vim.cmd.checktime()
				fn.setloclist(fn.winnr(), {}, " ", {
					title = "eslint -- errors",
					lines = results,
					efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
				})
				vim.cmd.lwindow()
				vim.lsp.buf_attach_client(0, 1)
			end)
		end,
	})
end

return M
