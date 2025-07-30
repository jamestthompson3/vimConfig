local node = require("tt.nvim_utils").nodejs

local fn = vim.fn
local api = vim.api

local M = {}

local prettier_roots = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.js",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.json5",
	".prettierrc.mjs",
	".prettierrc.cjs",
	".prettierrc.toml",
}

local eslint_roots = {
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
}

function M.bootstrap()
	if vim.bo.readonly ~= true then
		require("tt.snippets.ft.ecmascript")
	end
	vim.bo.suffixesadd = ".js,.jsx,.ts,.tsx"
	vim.bo.include = "^\\s*[^/]\\+\\(from\\|require(['\"]\\)"
	vim.bo.define = "class\\s"
	vim.wo.foldlevel = 99

	api.nvim_command([[command! Sort lua require'tt.ft.ecma'.import_sort(true)]])
	api.nvim_command([[command! Eslint lua require'tt.ft.ecma'.linter_d()]])
	api.nvim_command([[command! Lint lua require'tt.ft.ecma'.lint_project()]])
	api.nvim_command([[command! Run lua require'tt.ft.ecma'.run_yarn()]])

	-- optionally enable formatters/linters
	if vim.fs.root(0, eslint_roots) then
		require("tt.lsp.efm")
		vim.lsp.start(vim.lsp.config.efm)
	end

	if vim.fs.root(0, prettier_roots) then
		vim.b.autoformat = true
	end
end

function M.import_sort(async, cb)
	local path = fn.fnameescape(fn.expand("%:p"))
	local executable_path = node.find_node_executable("import-sort")

	if fn.executable(executable_path) then
		if true == async then
			vim.fn.jobstart({
				executable_path,
				path,
				"--write",
			}, {
				stdout_buffered = true,
				stderr_buffered = true,
				on_stdout = function(_, data)
					if #data > 0 and data[1] ~= "" then
						vim.schedule(function()
							print(vim.inspect(data))
						end)
					end
				end,
				on_stderr = function(_, data)
					if #data > 0 and data[1] ~= "" then
						vim.schedule(function()
							for _, line in ipairs(data) do
								if line ~= "" then
									error("IMPORT_SORT: " .. line)
								end
							end
						end)
					end
				end,
				on_exit = function(_, code)
					if code == 0 then
						vim.schedule(function()
							vim.api.nvim_command([[checktime]])
							if cb ~= nil then
								cb()
							end
						end)
					end
				end,
			})
		else
			fn.system(executable_path .. " " .. path .. " " .. "--write")
			vim.api.nvim_command([[checktime]])
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
	local linterResults = {}

	vim.fn.jobstart({
		executable_path,
		".",
		"--ext",
		".js,.ts,.tsx,.jsx",
		"--max-warnings=0",
		"-f",
		"compact",
		"--fix",
	}, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if #data > 0 and data[1] ~= "" then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(linterResults, line)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if #data > 0 and data[1] ~= "" then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(linterResults, line)
					end
				end
			end
		end,
		on_exit = function(_, _)
			vim.schedule(function()
				fn.setloclist(fn.winnr(), {}, " ", {
					title = "eslint -- errors",
					lines = linterResults,
					efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
				})
				api.nvim_command([[lwindow]])
			end)
		end,
	})
end

function M.linter_d()
	local path = fn.fnameescape(fn.expand("%:p"))
	local executable_path = node.find_node_executable("eslint_d")
	local linterResults = {}

	vim.fn.jobstart({
		executable_path,
		path,
		"-f",
		"compact",
		"--fix",
	}, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data)
			if #data > 0 and data[1] ~= "" then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(linterResults, line)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if #data > 0 and data[1] ~= "" then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(linterResults, line)
					end
				end
			end
		end,
		on_exit = function(_, _)
			vim.schedule(function()
				vim.api.nvim_command([[checktime]])
				fn.setloclist(fn.winnr(), {}, " ", {
					title = "eslint -- errors",
					lines = linterResults,
					efm = "%f: line %l\\, col %c\\, %m,%-G%.%#",
				})
				api.nvim_command([[lwindow]])
				vim.lsp.buf_attach_client(0, 1)
			end)
		end,
	})
end

function M.sort_and_lint()
	M.import_sort(true, M.linter_d)
end

function M.run_yarn()
	local function getscripts()
		local vals = vim.system({ "jq", ".scripts | keys", "package.json", "-a" }):wait()
		result = vim.json.decode(vals.stdout)
		return result
	end
end

return M
