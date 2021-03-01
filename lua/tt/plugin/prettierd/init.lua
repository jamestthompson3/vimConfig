local api = vim.api
local vcmd = vim.cmd
local vfn = vim.fn
local loop = vim.loop
local cmd = require('tt.plugin.prettierd.lib.cmd')
local helpers = require('tt.plugin.prettierd.lib.nvim_helpers')

local state = {running = false; port = 0; token = ''}

local M = {}

local function load_state()
  local state_file = string.format('%s/.prettierd', loop.os_homedir())
  local f = io.open(state_file)
  local contents = f:read('all*')
  f:close()

  local parts = vim.split(contents, ' ')
  if #parts ~= 2 then
    error('invalid state file: ' .. contents)
  end
  state.running = true
  state.port = tonumber(parts[1])
  state.token = parts[2]
end

local function start_server()
  local exec_path = string.format('%s/langservers/node_modules/.bin/prettierd', vfn.stdpath('config'))
  if 0 == vfn.executable(exec_path) then
    error("CANNOT FIND PRETTIER_D")
  end
  cmd.run(exec_path, {args = {'start'}}, nil, function(result)
    if result.exit_status ~= 0 then
      error(string.format('failed to start prettierd - %d: %s', result.exit_status, result.stderr))
    end

    load_state()
  end)

  require('tt.plugin.prettierd.lib.cleanup').register(function()
    local block = cmd.run('pkill', {args = {'prettierd'}}, nil, function()
    end)
    block(500)
  end)
end

local function wait_for_server(timeout_ms)
  timeout_ms = timeout_ms or 200
  local status = vim.wait(timeout_ms, function()
    return state.running
  end, 25)

  if not status then
    error(string.format('server didnt start after %dms', timeout_ms))
  end
end

function M.format(bufnr, cb, is_retry)
  if not state.running then
    start_server()
    wait_for_server(1000)
  end

  local changed_tick = api.nvim_buf_get_changedtick(bufnr)
  local fname = api.nvim_buf_get_name(bufnr)
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local cwd = loop.cwd()
  table.insert(lines, 1, string.format('%s %s %s', state.token, cwd,
                                       helpers.ensure_path_relative_to_prefix(cwd, fname)))

  local function write_to_buf(data)
    if changed_tick ~= api.nvim_buf_get_changedtick(bufnr) then
      return
    end

    local new_lines = vim.split(data, '\n')
    while new_lines[#new_lines] == '' do
      table.remove(new_lines, #new_lines)
    end

    if vim.tbl_isempty(new_lines) then
      return
    end

    if string.find(new_lines[#new_lines], '^# exit %d+') then
      error(string.format('failed to format with prettier: %s', data))
    end

    helpers.rewrite_wrap(function()
      local write = false
      for i, line in ipairs(new_lines) do
        if line ~= lines[i + 1] then
          write = true
          break
        end
      end
      if write then
        api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
      end

      if cb ~= nil then
        cb()
      end
    end)
  end

  local client = loop.new_tcp()
  loop.tcp_connect(client, '127.0.0.1', state.port, function(err)
    if err then
      state.running = false
      if is_retry then
        error('failed to connect to prettierd: ' .. err)
      else
        return M.format(bufnr, cb, true)
      end
    end

    local data = ''
    loop.read_start(client, function(read_err, chunk)
      if read_err then
        error('failed to read data from prettierd: ' .. read_err)
      end
      if chunk then
        data = data .. chunk
      else
        loop.close(client)
        vim.schedule(function()
          write_to_buf(data)
        end)
      end
    end)

    loop.write(client, table.concat(lines, '\n'))
    loop.shutdown(client)
  end)
end

local function autofmt_and_write(bufnr)
  local enable = require('tt.plugin.prettierd.lib.autofmt').is_enabled()
  if not enable then
    return
  end
  M.format(bufnr, function()
    vcmd('update')
  end)
end

nvim.command [[command! Pretty lua require'tt.plugin.prettierd'.format()]]

function M.setup_autofmt(bufnr)
  helpers.augroup('prettierd_autofmt_' .. bufnr, {
    {
      events = {'BufWritePost'};
      targets = {string.format('<buffer=%d>', bufnr)};
      command = helpers.fn_cmd(function()
        autofmt_and_write(bufnr)
        nvim.command("doautocmd User prettierd_autofmt")
      end);
    };
  })
end

return M
