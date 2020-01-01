require 'nvim_utils'
local api = vim.api
require 'navigation'

local sessionPath = '~'.. file_separator .. 'sessions' .. file_separator


local M = {}

function M.openQuickfix()
  local qflen = tonumber(api.nvim_exec('echo len(getqflist())', true))
  local qfheight = math.min(10, qflen)
  api.nvim_command(string.format("cclose|%dcwindow", qfheight))
end

function M.openTerminalDrawer(floating)
  if floating == 1 then
    NavigationFloatingWin()
  else
    api.nvim_command [[ copen ]]
  end
  api.nvim_command [[ term ]]
  api.nvim_input('i')
end

function M.renameFile()
  local oldName = api.nvim_get_current_line()
  local input_cmd = string.format("input('Rename: ', '%s', 'file')", oldName)
  local newName = api.nvim_eval(input_cmd)
  os.rename(oldName, newName)
  api.nvim_input('R')
end

function M.deleteFile()
  local fileName = api.nvim_get_current_line()
  os.remove(fileName)
  api.nvim_input('R')
end

function M.makeScratch()
  api.nvim_command [[enew]]
  vim.bo[0].buftype='nofile'
  vim.bo[0].bufhidden='hide'
  vim.bo[0].swapfile=false
  api.nvim_buf_set_keymap(0, 'n', 'q', ':bd<CR>', {noremap = true, silent = true})
end


function M.replaceQf(term1, term2)
  local replaceString = string.format("\\<%s\\>/%s/g", term1, term2)
  local cmd = "silent cfdo %s/" .. replaceString .. ' | update'
  api.nvim_command(cmd)
end

function M.grepBufs(term)
  local cmd = string.format("silent bufdo grepadd %s %", term)
  api.nvim_command(cmd)
end

-- Session Management
function M.createSessionName()
  local sessionName = gitBranch()
  local currDir = os.getenv('PWD')
  if not sessionName == '' or sessionName == 'master'then
    -- TODO doesn't work at all
    return "" --currDir
  else
    return sessionName
  end
end

function M.saveSession()
  local sessionName = M.createSessionName()
  local cmd = string.format("mks! %s%s.vim", sessionPath, sessionName)
  api.nvim_exec(cmd, false)
end

function M.sourceSession()
  local sessionName = M.createSessionName()
  local cmd = string.format("so! %s%s.vim", sessionPath, sessionName)
  api.nvim_exec(cmd, false)
end

function M.simpleMRU()
  local files = vim.v.oldfiles
  local cwd = api.nvim_exec('pwd', true)
  for _, file in ipairs(files) do
    -- print(getPath(file))
    if string.match(getPath(file), getPath(cwd)) then
      print(file:gsub(getPath(cwd), ''))
    end
    if not vim.startswith(file, 'term://') and string.match(getPath(file), getPath(cwd)) then
      local prettyName = file:gsub(cwd, ".")
      api.nvim_command(string.format('call append(line("$") -1, "%s")', vim.trim(prettyName)))
    end
    api.nvim_command[[:1]]
  end
end

function M.listTags()
  local cword = api.nvim_exec("echo expand('<cword>')", true)
  api.nvim_command('ltag '..cword)
  api.nvim_command [[ lwindow ]]
end

return M
