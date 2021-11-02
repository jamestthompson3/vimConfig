require('tt.nvim_utils')
local api = vim.api
local fn = vim.fn
require('tt.navigation')
local icons = require("nvim-nonicons")

local sessionPath = '~'.. file_separator .. 'sessions' .. file_separator


local M = {}

function M.openQuickfix()
  local qflen = fn.len(fn.getqflist())
  local qfheight = math.min(10, qflen)
  api.nvim_command(string.format("cclose|%dcwindow", qfheight))
end

function M.compile_theme()
  local lines = require("lush").compile(require("lush_theme.substrata"))
  vim.fn.writefile(lines, "colors/substrata.vim")
end

function M.splashscreen()
  local curr_buf = api.nvim_get_current_buf()
  local args = vim.fn.argc()
  local offset = api.nvim_buf_get_offset(curr_buf, 1)
  local currDir = os.getenv('PWD')
  if offset == -1 and args == 0 then
    api.nvim_create_buf(false, true)
    nvim.command [[ silent! r ~/vim/skeletons/start.screen ]]
    nvim.command(string.format("chdir %s", currDir))
    vim.bo[0].bufhidden='wipe'
    vim.bo[0].buflisted=false
    vim.bo[0].matchpairs=''
    nvim.command [[setl relativenumber]]
    -- nvim.command [[setl nocursorline]]
    vim.wo[0].cursorcolumn=false
    require('tt.tools').simpleMRU()
    nvim.command [[:34]]
    api.nvim_buf_set_keymap(0, 'n', '<CR>', 'gf', {noremap = true})
    vim.bo[0].modified=false
    vim.bo[0].modifiable=false
  else
  end

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

function M.restoreFile()
  local cmd = "git restore "..fn.expand("%")
  api.nvim_command("!"..cmd)
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

function M.winMove(key)
  local currentWindow = fn.winnr()
  nvim.command("wincmd " .. key)
  if fn.winnr() == currentWindow  then
    if key == 'j' or key == 'k' then
      nvim.command("wincmd s")
    else
      nvim.command("wincmd v")
    end
    nvim.command("wincmd " .. key)
  end
end

function M.markMargin()
  if 1 == fn.exists('b:MarkMargin') then
    fn.matchadd('ErrorMsg', '\\%>' .. vim.b.MarkMargin .. 'v\\s*\\zs\\S', 0)
  end
end

function M.removeWhitespace()
  if 1 == vim.g.remove_whitespace then
    api.nvim_exec("normal mz", false)
    nvim.command("%s/\\s\\+$//ge")
    api.nvim_exec("normal `z", false)
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
    return "default" --currDir
  else
    return sessionName:gsub("/", "-")
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
  local cwd = os.getenv('PWD')
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

function M.asyncGrep(...)
  local terms = {...}
  local results = {}
  local function onread(err, data)
    if err then
      print('GREP ERROR: ', err)
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
  local function setQF()
    fn.setqflist({}, 'r', {title = 'Search Results', lines = results})
    api.nvim_command [[ cwindow ]]
  end
  local args = fn.extend(terms, {'--vimgrep', '--smart-case', '--block-buffered'})
  spawn('rg', {
    args = args,
    stdio = {nil, _,_}
  },
  {stdout = onread, stderr = onread},
  vim.schedule_wrap(function()
    setQF()
  end
  )
  )
end


function M.statuslineIcon()
  local fileName = vim.fn.fnamemodify(api.nvim_buf_get_name(0),':p:t')
  local extension = vim.fn.fnamemodify(api.nvim_buf_get_name(0),':e')
  local icon, icon_highlight = icons.get_icon(fileName, extension, {default = true})
  if icon ~= nil then
    -- local iconHighlight = icons.get_highlight_name(icon)
    -- TODO load dynamic parts of the statusline on augroups?
    -- statusline = icon .. ' '
    return icon .. ' '
  end
  return ""
end

function M.statuslineHighlight()
  local fileName = vim.fn.fnamemodify(api.nvim_buf_get_name(0),':p:t')
  local extension = vim.fn.fnamemodify(api.nvim_buf_get_name(0),':e')
  local icon, icon_highlight = icons.get_icon(fileName, extension, {default = true})
  return icon_highlight
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

M.kind_symbols = {
	Text = " Text",
	Method = "ƒ Method",
	Function = icons.get("pulse") .. " Func",
	Constructor = " Constructor",
	Variable = icons.get("variable") .. " Var",
	Class = icons.get("class") .. " Class",
	Interface = "ﰮ" .. " Interface",
	Module = icons.get("package") .. " Module",
	Property = " Property",
	Unit = " Unit",
	Value = icons.get("ellipsis") .. " Value",
	Enum = icons.get("workflow") .. " Enum",
	Keyword = " Keyword",
	Snippet = "﬌ Snippet",
	Color = " Color",
	File = icons.get("file") .. " File",
	Folder = icons.get("file-directory-outline") .. " Folder",
	EnumMember = " EnumMember",
	Constant = icons.get("constant") .. " Constant",
	Struct = icons.get("struct") .. " Struct",
}

return M
