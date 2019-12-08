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
  print(cmd)
  api.nvim_command(cmd)
end

return M

