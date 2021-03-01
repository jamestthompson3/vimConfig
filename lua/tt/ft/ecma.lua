require('tt.nvim_utils')
require'tt.user_lsp'.setMappings()

local fn = vim.fn
require('tt.plugin.prettierd').setup_autofmt(fn.expand('<abuf>'))

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
  local autocmds = {
    ecmascript = {
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

function M.import_sort(async)
  local path = fn.fnameescape(fn.expand("%:p"))
  local executable_path = find_executable("import-sort")
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)


  if fn.executable(executable_path) then
    if true == async then
      handle = vim.loop.spawn(executable_path, {
        args = {path, "--write"},
        stdio = {stdout,stderr}
      },
      vim.schedule_wrap(function()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()
        vim.api.nvim_command[["checktime"]]
      end
      )
      )
      vim.loop.read_start(stdout, onread)
      vim.loop.read_start(stderr, onread)
    else
      fn.system(executable_path .. " " .. path .. " " .. "--write")
      vim.api.nvim_command[["checktime"]]
    end
  else
    error("Cannot find import-sort executable")
  end
end


function M.linter_d()
  local path = fn.fnameescape(fn.expand("%:p"))
  local executable_path = find_executable("eslint_d")
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
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
  handle = vim.loop.spawn(executable_path, {
    args = {path, "-f", "compact", "--fix"},
    stdio = {stdout,stderr}
  },
  vim.schedule_wrap(function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
    vim.api.nvim_command[["checktime"]]
    fn.setqflist({}, ' ', {title = "eslint -- errors", lines = linterResults, efm = "%f: line %l\\, col %c\\, %m,%-G%.%#"})
    nvim.command[[cwindow]]
  end
  )
  )
  vim.loop.read_start(stdout, readlint)
  vim.loop.read_start(stderr, readlint)
end

function M.sort_and_lint()
  local path = fn.fnameescape(fn.expand("%:p"))
  local executable_path = find_executable("import-sort")
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local function onread(err, data)
    if err then
      error("IMPORT_SORT: ", err)
    end
  end

  if fn.executable(executable_path) then
      handle = vim.loop.spawn(executable_path, {
        args = {path, "--write"},
        stdio = {stdout,stderr}
      },
      vim.schedule_wrap(function()
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        handle:close()
        vim.api.nvim_command[["checktime"]]
        M.linter_d()
      end
      )
      )
      vim.loop.read_start(stdout, onread)
      vim.loop.read_start(stderr, onread)
    end
end

return M