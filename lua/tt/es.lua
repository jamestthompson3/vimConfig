require('tt.nvim_utils')
require'tt.user_lsp'.setMappings()

local fn = vim.fn

local M = {}

function M.bootstrap()
  vim.bo.suffixesadd = ".js",".jsx",".ts",".tsx"
  vim.bo.include = "^\\s*[^/]\\+\\(from\\|require(['\"]\\)"
  vim.bo.define = "class\\s"
  vim.wo.foldlevel = 99
  vim.b.ale_fixers = {'prettier'}
  vim.b.ale_linters = {'eslint'}

  local mappings = {
    ["i<C-l>"]  = {"console.log()<esc>i", noremap = true, buffer = true},
    ["i<C-c>"]  = {"console.log('%c%o', 'color: ;')<esc>F%;la", noremap = true, buffer = true},
    ["id<C-l>"] = {"debugger", noremap = true, buffer = true}
  }

  nvim_apply_mappings(mappings, {silent = true})
  nvim.command [[command! Sort lua require'tt.es'.import_sort(true)]]
  local autocmds = {
    ecmascript = {
      {"BufWritePre",     "<buffer>",      [[lua require'tt.es'.import_sort()]]};
    };
  }
  nvim_create_augroups(autocmds)

end

local function find_executable()
  local import_sort_executable = fn.getcwd() .. "/node_modules/.bin/import-sort"
  if 0 == fn.executable(import_sort_executable) then
    local sub_cmd =  fn.system("git rev-parse --show-toplevel")
    local project_root_path = sub_cmd:gsub("\n","")
    import_sort_executable = project_root_path .. "/node_modules/.bin/import-sort"
  end

  if 0 == fn.executable(import_sort_executable) then
    import_sort_executable = "import-sort"
  end
  return import_sort_executable
end

local function onread(err, data)
  if err then
    error("IMPORT_SORT: ", err)
  end
end

function M.import_sort(async)
  local winview = fn.winsaveview()
  local path = fn.fnameescape(fn.expand("%:p"))
  local executable_path = find_executable()
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
        fn.winrestview(winview)
      end
      )
      )
      vim.loop.read_start(stdout, onread)
      vim.loop.read_start(stderr, onread)
    else
      log("SORTING...")
      fn.system(executable_path .. " " .. path .. " " .. "--write")
      vim.api.nvim_command[["checktime"]]
      fn.winrestview(winview)
    end
  else
    error("Cannot find import-sort executable")
  end
end

return M
