local helpers = require('tt.plugin.prettierd.lib.nvim_helpers')

local cbs = {}

local M = {}

function M.register(fn)
  table.insert(cbs, fn)
end

local function cleanup()
  local finished = 0
  for _, cb in pairs(cbs) do
    vim.schedule(function()
      cb()
      finished = finished + 1
    end)
  end

  vim.wait(500, function()
    return finished == #cbs
  end, 25)
end

function M.setup()
  helpers.augroup('fsouza__lua_lib_cleanup',
                  {{events = {'VimLeavePre'}; targets = {'*'}; command = helpers.fn_cmd(cleanup)}})
end

return M

