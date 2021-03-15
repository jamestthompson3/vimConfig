require('tt.nvim_utils')
require'tt.user_lsp'.setMappings()

local fn = vim.fn

local M = {}

function M.bootstrap()
  vim.bo.suffixesadd = ".js",".jsx",".ts",".tsx"
  vim.bo.include = "^\\s*[^/]\\+\\(from\\|require(['\"]\\)"
  vim.bo.define = "class\\s"
  vim.wo.foldlevel = 99

  local mappings = {
    ["i<C-l>"]  = {"console.log()<esc>i", noremap = true, buffer = true},
    ["i<C-c>"]  = {"console.log('%c%o', 'color: ;')<esc>F%;la", noremap = true, buffer = true},
    ["id<C-l>"] = {"debugger", noremap = true, buffer = true}
  }

  nvim_apply_mappings(mappings, {silent = true})
  nvim.command [[command! Sort lua require'tt.ft.ecma'.import_sort(true)]]
  nvim.command [[command! Eslint lua require'tt.ft.ecma'.linter_d()]]
  nvim.command [[command! Lint lua require'tt.ft.ecma'.lint_project()]]
  local autocmds = {
    ecmascript = {
      -- {"User prettierd_autofmt lua require'tt.ft.ecma'.import_sort(true, function() vim.lsp.buf_attach_client(0,1)end)"},
      {"User prettierd_autofmt lua require'tt.ft.ecma'.sort_and_lint()"}
    };
  }
  nvim_create_augroups(autocmds)

end

local function find_executable(binaryName)
  local executable = fn.getcwd() .. "/node_modules/.bin/" .. binaryName
  if 0 == fn.executable(executable) then
    local sub_cmd =  fn.system("git rev-parse --show-toplevel")
    local project_root_path = sub_cmd:gsub("\n","")
    executable = project_root_path .. "/node_modules/.bin/" .. binaryName
  end

  if 0 == fn.executable(executable) then
    executable = get_node_bin(binaryName)
  end
  if 0 == fn.executable(executable) then
    log(string.format("Could not find: %s", executable))
  end
  return executable
end

local function onread(err, data)
  if err then
    error("IMPORT_SORT: ", err)
  end
end

function M.import_sort(async, cb)
  local path = fn.fnameescape(fn.expand("%:p"))
  local executable_path = find_executable("import-sort")

  if fn.executable(executable_path) then
    if true == async then
      spawn(executable_path, {
        args = {path, "--write"}
      },
      {stdout = onread, stderr = onread},
      vim.schedule_wrap(function()
        vim.api.nvim_command[["checktime"]]
        if cb ~= nil then
          cb()
        end
      end
      )
      )
    else
      fn.system(executable_path .. " " .. path .. " " .. "--write")
      vim.api.nvim_command[["checktime"]]
      if cb ~= nil then
        cb()
      end
    end
  else
    error("Cannot find import-sort executable")
  end
end

function M.lint_project()
  local executable_path = find_executable("eslint_d")
  local linterResults = {}
  local function readlint(err, data)
    if data then
      table.insert(linterResults, data)
      local vals = vim.split(data, "\n")
      for _, line in pairs(vals) do
        if line and line ~= '' then
          linterResults[#linterResults + 1] = line
        end
      end
    end
  end
  ----ext .js,.ts,.tsx --max-warnings=0
  spawn(executable_path, {
    args = {".", "--ext", ".js,.ts,.tsx,.jsx", "--max-warnings=0", "-f", "compact", "--fix"}
  },
  {stdout = readlint, stderr = readlint},
  vim.schedule_wrap(function()
    if not vim.tbl_isempty(linterResults) then
      fn.setloclist(fn.winnr(), {}, ' ', {title = "eslint -- errors", lines = linterResults, efm = "%f: line %l\\, col %c\\, %m,%-G%.%#"})
      nvim.command[[lwindow]]
    end
  end
  )
  )
end


function M.linter_d()
  local path = fn.fnameescape(fn.expand("%:p"))
  local executable_path = find_executable("eslint_d")
  local linterResults = {}
  local function readlint(err, data)
    if data then
      table.insert(linterResults, data)
      local vals = vim.split(data, "\n")
      for _, line in pairs(vals) do
        if line and line ~= '' then
          linterResults[#linterResults + 1] = line
        end
      end
    end
  end
  spawn(executable_path, {
    args = {path, "-f", "compact", "--fix"}
  },
  {stdout = readlint, stderr = readlint},
  vim.schedule_wrap(function()
    vim.api.nvim_command[["checktime"]]
    if not vim.tbl_isempty(linterResults) then
      fn.setloclist(fn.winnr(), {}, ' ', {title = "eslint -- errors", lines = linterResults, efm = "%f: line %l\\, col %c\\, %m,%-G%.%#"})
      nvim.command[[lwindow]]
    end
    vim.lsp.buf_attach_client(0,1)
  end
  )
  )
end

function M.sort_and_lint()
  M.import_sort(true, M.linter_d)
end

return M
