require 'nvim_utils'
local api = vim.api

local M = {}

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
  api.nvim_buf_set_option(0, 'buftype', 'nofile')
  api.nvim_buf_set_option(0, 'bufhidden', 'hide')
  api.nvim_buf_set_option(0, 'swapfile', false)
end


function M.replaceQf(term1, term2)
  local replaceString = string.format("\\<%s\\>/%s/g", term1, term2)
  local cmd = "silent cfdo %s/" .. replaceString .. ' | update'
  api.nvim_command(cmd)
end

function M.createSessionName()
  local sessionName = gitBranch()
  local currDir = os.getenv('PWD')
  if not sessionName == '' or sessionName == 'master'then
    -- TODO doesn't work well
    return currDir
  else
    return sessionName
  end
end

function M.saveSession()
  local sessionName = M.createSessionName()
  print(sessionName)
  local cmd = string.format("mks! %s.vim", sessionName)
  api.nvim_exec(cmd, false)
end

function M.sourceSession()
  local sessionName = M.createSessionName()
  local cmd = string.format("so! %s.vim", sessionName)
  api.nvim_exec(cmd, false)
end

return M

