require 'nvim_utils'
local api = vim.api
local fn = vim.fn
require 'navigation'
local icons = require 'devicons'

local sessionPath = '~'.. file_separator .. 'sessions' .. file_separator


local M = {}

function M.configurePlugins()
  require 'navigation'

  vim.cmd [[packadd cfilter]]

  local nvim_lsp = require 'nvim_lsp'
  nvim_lsp.sumneko_lua.setup({})
  nvim_lsp.cssls.setup({})
  nvim_lsp.tsserver.setup({})

  nvim_lsp.rls.setup({})
  nvim_lsp.bashls.setup({})

  vim.fn['tools#loadCscope']()
  local diagnostic = require('user_lsp')
  vim.lsp.callbacks['textDocument/publishDiagnostics'] = diagnostic.diagnostics_callback

  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,                    -- false will disable the whole extension
    },
    incremental_selection = {
      enable = false,
      keymaps = {                       -- mappings for incremental selection (visual mappings)
      init_selection = 'gnn',         -- maps in normal mode to init the node/scope selection
      node_incremental = "grn",       -- increment to the upper named parent
      scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
      node_decremental = "grm",       -- decrement to the previous node
    }
  },
  refactor = {
    highlight_definitions = {
      enable = true
    },
    highlight_current_scope = {
      enable = false
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr"          -- mapping to rename reference under cursor
      }
    },
    navigation = {
      enable = false,
      keymaps = {
        goto_definition = "gnd",      -- mapping to go to definition of symbol under cursor
        list_definitions = "gnD"      -- mapping to list all definitions in current file
      }
    }
  },
  textobjects = { -- syntax-aware textobjects
  enable = false,
  disable = {},
  keymaps = {}
},
}
-- custom syntax since treesitter overrides nvim defaults
-- Doesn't work... :/
nvim.command [[match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$']]
nvim.command [[syntax match  AllTodo "(\ctodo\|fixme\|TODO\|FIXME):\?"]]

end

function M.openQuickfix()
  local qflen = fn.len(fn.getqflist())
  local qfheight = math.min(10, qflen)
  api.nvim_command(string.format("cclose|%dcwindow", qfheight))
end

function M.blameVirtText()
  local ft = fn.expand('%:h:t')
  if ft == '' then
    return
  end
  if ft == 'bin' then
    return
  end
  api.nvim_buf_clear_namespace(0, 99, 0, -1)
  local currFile = fn.expand('%')
  local line = api.nvim_win_get_cursor(0)
  local blame = fn.system(string.format('git blame -c -L %d,%d %s', line[1], line[1], currFile))
  local hash = vim.split(blame, '%s')[1]
  local cmd = string.format("git show %s ", hash).."--format='%an, %ar • %s'"
  if hash == '00000000' then
    text = 'Not Committed Yet'
  else
    text = fn.system(cmd)
    text = vim.split(text, '\n')[1]
    if text:find("fatal") then
      text = 'Not Committed Yet'
    end
  end
  api.nvim_buf_set_virtual_text(0, 99, line[1] - 1, {{ text,'GitLens' }}, {})
end

function M.clearBlameVirtText()
  api.nvim_buf_clear_namespace(0, 99, 0, -1)
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

function M.lazyGit()
  NavigationFloatingWin()
  api.nvim_command [[ term lazygit ]]
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

function M.listFiles(pattern)
  fn.setqflist({}, 'r', {title = 'Files', lines = results, efm = '%f'})
  nvim.command[[copen]]
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

function M.fastFind(pattern)
  local found = fn.systemlist("fd --color never --type f "..pattern)
  local foundlen = fn.len(found)
  if foundlen > 0 then
    api.nvim_command('edit '..found[1])
  end
end


function M.grepBufs(term)
  local cmd = string.format("silent bufdo vimgrepadd %s %", term)
  api.nvim_command(cmd)
end

-- Session Management
function M.createSessionName()
  local sessionName = gitBranch()
  local currDir = os.getenv('PWD')
  if not sessionName == '' or sessionName == 'master' then
    return "" --currDir
  else
    return sessionName
  end
end

function M.saveSession()
  local sessionName = M.createSessionName()
  local cmd = string.format("mks! %s%s.vim", sessionPath, sessionName)
  api.nvim_command(cmd)
end

function M.sourceSession()
  local sessionName = M.createSessionName()
  local cmd = string.format("so %s%s.vim", sessionPath, sessionName)
  api.nvim_command(cmd)
end

function M.simpleMRU()
  local files = vim.v.oldfiles
  local cwd = getPath(api.nvim_exec('pwd', true))
  for _, file in ipairs(files) do
    if not vim.startswith(file, 'term://') and string.match(getPath(file), cwd) then
      local splitvals = vim.split(file, "/")
      local fname = splitvals[#splitvals]
      api.nvim_command(string.format('call append(line("$") -1, "%s")', vim.trim(fname)))
    end
  end
  api.nvim_command[[:1]]
end

function M.listTags()
  local cword = fn.expand('<cword>')
  api.nvim_command('ltag '..cword)
  api.nvim_command [[ lwindow ]]
end

local results = {}
local function onread(err, data)
  if err then
    -- print('ERROR: ', err)
    -- TODO handle err
  end
  if data then
    local vals = vim.split(data, "\n")
    for _, d in pairs(vals) do
      if d == "" then goto continue end
      table.insert(results, d)
      ::continue::
    end
  end
end

function M.asyncGrep(...)
  local terms = {...}
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local function setQF()
    fn.setqflist({}, 'r', {title = 'Search Results', lines = results})
    api.nvim_command [[ cwindow ]]
    local count = #results
    for i=0, count do results[i]=nil end -- clear the table
  end
  args = fn.extend(terms, {'--vimgrep', '--smart-case', '--block-buffered'})
  handle = vim.loop.spawn('rg', {
    args = args,
    stdio = {stdout,stderr}
  },
  vim.schedule_wrap(function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
    setQF()
  end
  )
  )
  vim.loop.read_start(stdout, onread)
  vim.loop.read_start(stderr, onread)
end


function M.setStatusLine()
  local statusline = ""
  local fileName = vim.fn.fnamemodify(api.nvim_buf_get_name(0),':p:t')
  local icon = icons.deviconTable[vim.fn.fnamemodify(api.nvim_buf_get_name(0),':p:t')]
  if icon ~= nil then
    fileName = icon .. ' ' .. fileName
  end
  return fileName
end

function M.profile()
  if vim.g.profiler_running ~= nil then
    api.nvim_command('profile pause')
    vim.g.profiler_running = nil
    api.nvim_command('noautocmd qall!')
  else
    vim.g.profiler_running = 1
    api.nvim_command('profile start profile.log')
    api.nvim_command('profile func *')
    api.nvim_command('profile file *')
  end
end

return M
