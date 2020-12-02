--- NVIM SPECIFIC SHORTCUTS
vim = vim or {}
api = vim.api
fn = vim.fn

local valid_modes = {
  n = 'n'; v = 'v'; x = 'x'; i = 'i';
  o = 'o'; t = 't'; c = 'c'; s = 's';
  -- :map! and :map
  ['!'] = '!'; [' '] = '';
}

function map_cmd(cmd_string, buflocal)
  return { ("<Cmd>%s<CR>"):format(cmd_string), noremap = true; buffer = buflocal;}
end

file_separator = is_windows and '\\' or '/'
is_windows = vim.loop.os_uname().version:match("Windows")

function nvim_apply_mappings(mappings, default_options)
  -- May or may not be used.
  local current_bufnr = vim.api.nvim_get_current_buf()
  for key, options in pairs(mappings) do
    options = vim.tbl_extend("keep", options, default_options or {})
    local bufnr = current_bufnr
    -- TODO allow passing bufnr through options.buffer?
    -- protect against specifying 0, since it denotes current buffer in api by convention
    if type(options.buffer) == 'number' and options.buffer ~= 0 then
      bufnr = options.buffer
    end
    local mode, mapping = key:match("^(.)(.+)$")
    assert(mode, "nvim_apply_mappings: invalid mode specified for keymapping "..key)
    assert(valid_modes[mode], "nvim_apply_mappings: invalid mode specified for keymapping. mode="..mode)
    mode = valid_modes[mode]
    local rhs = options[1]
    -- Remove this because we're going to pass it straight to nvim_set_keymap
    options[1] = nil
    if type(rhs) == 'function' then
      -- Use a value that won't be misinterpreted below since special keys
      -- like <CR> can be in key, and escaping those isn't easy.
      local escaped = escape_keymap(key)
      local key_mapping
      if options.dot_repeat then
        local key_function = rhs
        rhs = function()
          key_function()
          -- -- local repeat_expr = key_mapping
          -- local repeat_expr = mapping
          -- repeat_expr = vim.api.nvim_replace_termcodes(repeat_expr, true, true, true)
          -- nvim.fn["repeat#set"](repeat_expr, nvim.v.count)
          nvim.fn["repeat#set"](nvim.replace_termcodes(key_mapping, true, true, true), nvim.v.count)
        end
        options.dot_repeat = nil
      end
      if options.buffer then
        -- Initialize and establish cleanup
        if not LUA_BUFFER_MAPPING[bufnr] then
          LUA_BUFFER_MAPPING[bufnr] = {}
          -- Clean up our resources.
          vim.api.nvim_buf_attach(bufnr, false, {
            on_detach = function()
              LUA_BUFFER_MAPPING[bufnr] = nil
            end
          })
        end
        LUA_BUFFER_MAPPING[bufnr][escaped] = rhs
        -- TODO HACK figure out why <Cmd> doesn't work in visual mode.
        if mode == "x" or mode == "v" then
          key_mapping = (":<C-u>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(bufnr, escaped)
        else
          key_mapping = ("<Cmd>lua LUA_BUFFER_MAPPING[%d].%s()<CR>"):format(bufnr, escaped)
        end
      else
        LUA_MAPPING[escaped] = rhs
        -- TODO HACK figure out why <Cmd> doesn't work in visual mode.
        if mode == "x" or mode == "v" then
          key_mapping = (":<C-u>lua LUA_MAPPING.%s()<CR>"):format(escaped)
        else
          key_mapping = ("<Cmd>lua LUA_MAPPING.%s()<CR>"):format(escaped)
        end
      end
      rhs = key_mapping
      options.noremap = true
      options.silent = true
    end
    if options.buffer then
      options.buffer = nil
      vim.api.nvim_buf_set_keymap(bufnr, mode, mapping, rhs, options)
    else
      vim.api.nvim_set_keymap(mode, mapping, rhs, options)
    end
  end
end


function log(item)
  print(vim.inspect(item))
end

--- Check if a file or directory exists in this path
function exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
function isdir(path)
  -- "/" works on both Unix and Windows
  return exists(path.."/")
end


function getPath(str)
  local s = str:gsub("%-","")
  return s:match("(.*[/\\])")
end

-- Equivalent to `echo vim.inspect(...)`
function nvim_print(...)
  if select("#", ...) == 1 then
    vim.api.nvim_out_write(vim.inspect((...)))
  else
    vim.api.nvim_out_write(vim.inspect {...})
  end
  vim.api.nvim_out_write("\n")
end

--- Equivalent to `echo` EX command
function nvim_echo(...)
  for i = 1, select("#", ...) do
    local part = select(i, ...)
    vim.api.nvim_out_write(tostring(part))
    -- vim.api.nvim_out_write("\n")
    vim.api.nvim_out_write(" ")
  end
  vim.api.nvim_out_write("\n")
end

-- `nvim.$method(...)` redirects to `nvim.api.nvim_$method(...)`
-- `nvim.fn.$method(...)` redirects to `vim.api.nvim_call_function($method, {...})`
-- TODO `nvim.ex.$command(...)` is approximately `:$command {...}.join(" ")`
-- `nvim.print(...)` is approximately `echo vim.inspect(...)`
-- `nvim.echo(...)` is approximately `echo table.concat({...}, '\n')`
-- Both methods cache the inital lookup in the metatable, but there is a small overhead regardless.
nvim = setmetatable({
  print = nvim_print;
  echo = nvim_echo;
  fn = setmetatable({}, {
    __index = function(self, k)
      local mt = getmetatable(self)
      local x = mt[k]
      if x ~= nil then
        return x
      end
      local f = function(...) return vim.api.nvim_call_function(k, {...}) end
      mt[k] = f
      return f
    end
  });
  buf = setmetatable({
    -- current = setmetatable({}, {
      -- 	__index = function(self, k)
        -- 		local mt = getmetatable(self)
        -- 		local x = mt[k]
        -- 		if x ~= nil then
        -- 			return x
        -- 		end
        -- 		local command = k:gsub("_$", "!")
        -- 		local f = function(...) return vim.api.nvim_command(command.." "..table.concat({...}, " ")) end
        -- 		mt[k] = f
        -- 		return f
        -- 	end
        -- });
      }, {
        __index = function(self, k)
          local mt = getmetatable(self)
          local x = mt[k]
          if x ~= nil then
            return x
          end
          local f = vim.api['nvim_buf_'..k]
          mt[k] = f
          return f
        end
      });
      ex = setmetatable({}, {
        __index = function(self, k)
          local mt = getmetatable(self)
          local x = mt[k]
          if x ~= nil then
            return x
          end
          local command = k:gsub("_$", "!")
          local f = function(...)
            return vim.api.nvim_command(table.concat(vim.tbl_flatten {command, ...}, " "))
          end
          mt[k] = f
          return f
        end
      });
      g = setmetatable({}, {
        __index = function(_, k)
          return vim.api.nvim_get_var(k)
        end;
        __newindex = function(_, k, v)
          if v == nil then
            return vim.api.nvim_del_var(k)
          else
            return vim.api.nvim_set_var(k, v)
          end
        end;
      });
      v = setmetatable({}, {
        __index = function(_, k)
          return vim.api.nvim_get_vvar(k)
        end;
        __newindex = function(_, k, v)
          return vim.api.nvim_set_vvar(k, v)
        end
      });
      b = setmetatable({}, {
        __index = function(_, k)
          return vim.api.nvim_buf_get_var(0, k)
        end;
        __newindex = function(_, k, v)
          if v == nil then
            return vim.api.nvim_buf_del_var(0, k)
          else
            return vim.api.nvim_buf_set_var(0, k, v)
          end
        end
      });
      o = setmetatable({}, {
        __index = function(_, k)
          return vim.api.nvim_get_option(k)
        end;
        __newindex = function(_, k, v)
          return vim.api.nvim_set_option(k, v)
        end
      });
      bo = setmetatable({}, {
        __index = function(_, k)
          return vim.api.nvim_buf_get_option(0, k)
        end;
        __newindex = function(_, k, v)
          return vim.api.nvim_buf_set_option(0, k, v)
        end
      });
      env = setmetatable({}, {
        __index = function(_, k)
          return vim.api.nvim_call_function('getenv', {k})
        end;
        __newindex = function(_, k, v)
          return vim.api.nvim_call_function('setenv', {k, v})
        end
      });
    }, {
      __index = function(self, k)
        local mt = getmetatable(self)
        local x = mt[k]
        if x ~= nil then
          return x
        end
        local f = vim.api['nvim_'..k]
        mt[k] = f
        return f
      end
    })

    nvim.option = nvim.o

    ---
    -- Higher level text manipulation utilities
    ---

    -- Necessary glue for nvim_text_operator
    -- Calls the lua function whose name is g:lua_fn_name and forwards its arguments
    vim.api.nvim_command [[
    function! LuaExprCallback(...) abort
    return luaeval(g:lua_expr, a:000)
    endfunction
    ]]

    LUA_MAPPING = {}
    LUA_BUFFER_MAPPING = {}

    local function escape_keymap(key)
      -- Prepend with a letter so it can be used as a dictionary key
      return 'k'..key:gsub('.', string.byte)
    end


    -- TODO(ashkan) @feature Disable noremap if the rhs starts with <Plug>

    function nvim_create_augroups(definitions)
      for group_name, definition in pairs(definitions) do
        vim.api.nvim_command('augroup '..group_name)
        vim.api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
          -- if type(def) == 'table' and type(def[#def]) == 'function' then
          -- 	def[#def] = lua_callback(def[#def])
          -- end
          local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
          vim.api.nvim_command(command)
        end
        vim.api.nvim_command('augroup END')
      end
    end

    ---
    -- Things Lua should've had
    ---

    function string.startswith(s, n)
      return s:sub(1, #n) == n
    end

    function string.endswith(self, str)
      return self:sub(-#str) == str
    end

    ---
    -- SPAWN UTILS
    ---

    local function clean_handles()
      local n = 1
      while n <= #HANDLES do
        if HANDLES[n]:is_closing() then
          table.remove(HANDLES, n)
        else
          n = n + 1
        end
      end
    end

    HANDLES = {}

    function spawn(cmd, params, onexit)
      local handle, pid
      handle, pid = vim.loop.spawn(cmd, params, function(code, signal)
        if type(onexit) == 'function' then onexit(code, signal) end
        handle:close()
        clean_handles()
      end)
      table.insert(HANDLES, handle)
      return handle, pid
    end

    --- MISC UTILS

    -- capturs stdout as a string
    function os.capture(cmd, raw)
      local f = assert(io.popen(cmd, 'r'))
      local s = assert(f:read('*a'))
      f:close()
      if raw then return s end
      s = string.gsub(s, '^%s+', '')
      s = string.gsub(s, '%s+$', '')
      s = string.gsub(s, '[\n\r]+', ' ')
      return s
    end


    -- return name of git branch
    function gitBranch()
      if is_windows then
        return os.capture("git rev-parse --abbrev-ref HEAD 2> NUL | tr -d '\n'")
      else
        return os.capture("git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d '\n'")
      end
    end

    -- returns short status of changes
    function gitStat()
      if is_windows then
        return os.capture("git diff --shortstat 2> NUL | tr -d '\n'")
      else
        return os.capture("git diff --shortstat 2> /dev/null | tr -d '\n'")
      end
    end

    function map_call(cmd_string, buflocal)
      return { ("%s<CR>"):format(cmd_string), noremap = true; buffer = buflocal;}
    end

    function map_no_cr(cmd_string, buflocal)
      return { (":%s"):format(cmd_string), noremap = true; buffer = buflocal;}
    end

    function openJobWindow()
      local lines = api.nvim_get_option("lines")
      local columns = api.nvim_get_option("columns")
      local height = fn.float2nr((lines - 2) * 0.3)
      local row = fn.float2nr((lines - height) / 2)
      local width = fn.float2nr(columns * 0.6)
      local col = fn.float2nr((columns - width) / 2)
      local border_opts = {
        relative = 'editor',
        row = row - 1,
        col = col - 2,
        width = width + 4,
        height = height + 2,
        style = 'minimal'
      }

      local opts = {
        relative = 'editor',
        row = row - 4,
        col = col,
        width = width,
        height = height,
        style = 'minimal'
      }
      local top = string.format("╭%s╮", string.rep("─", width + 2))
      local mid = string.format("│%s│",string.rep(" ", width + 2))
      local bot = string.format("╰%s╯", string.rep("─", width + 2))
      local bufLines = string.format("%s%s%s",top,string.rep(mid, height),bot)
      local bbuf = api.nvim_create_buf(false, true)
      api.nvim_buf_set_lines(bbuf, 0, -1, true, { bufLines })
      -- api.nvim_open_win(bbuf, true, border_opts)
      local buf = api.nvim_create_buf(false, true)
      local window = api.nvim_open_win(buf, true, opts)
      return { buf = buf, window = window }
    end
