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

-- Run eslint_d with `argv`, then feed its "compact" output into the location
-- list. `reload` re-reads the buffer after an on-disk `--fix` of the file.
local function run_eslint(argv, reload)
	local executable_path = node.find_node_executable("eslint_d")
	vim.system(vim.list_extend({ executable_path }, argv), { text = true }, function(result)
		vim.schedule(function()
			if reload then
				vim.cmd.checktime()
			end
			local lines = result.stdout and vim.split(result.stdout, "\n", { trimempty = true }) or {}
			fn.setloclist(0, {}, " ", {
				title = "eslint -- errors",
				lines = lines,
				efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
			})
			vim.cmd.lwindow()
		end)
	end)
end

function M.lint_project()
	run_eslint({ ".", "--ext", ".js,.ts,.tsx,.jsx", "--max-warnings=0", "-f", "compact", "--fix" }, false)
end

function M.linter_d()
	run_eslint({ fn.fnameescape(fn.expand("%:p")), "-f", "compact", "--fix" }, true)
end

return M
