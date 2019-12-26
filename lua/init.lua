require 'nvim_utils'
local api = vim.api
local home = os.getenv("HOME")

--- Check if a file or directory exists in this path
local function exists(file)
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
local function isdir(path)
  -- "/" works on both Unix and Windows
  return exists(path.."/")
end

local function create_backup_dir()
  local data_dir = home .. '/.cache/Vim/'
  local backup_dir = data_dir .. 'backup'
  local swap_dir = data_dir .. 'swap'
  local undo_dir = data_dir .. 'undofile'
  if not isdir(data_dir) then
    os.execute("mkdir" .. data_dir)
  end
  if not isdir(backup_dir) then
    os.execute("mkdir" .. backup_dir)
  end
  if not isdir(swap_dir) then
    os.execute("mkdir" .. swap_dir)
  end
  if not isdir(undo_dir) then
    os.execute("mkdir" .. undo_dir)
  end
end

create_backup_dir()

function splashscreen()
  local curr_buf = api.nvim_get_current_buf()
  local args = tonumber(api.nvim_exec('echo argc()', true))
  local offset = api.nvim_buf_get_offset(curr_buf, 1)
  local currDir = os.getenv('PWD')
  if offset == -1 and args == 0 then
    api.nvim_create_buf(false, true)
    api.nvim_command [[ silent! r ~/vim/skeletons/start.screen ]]
    api.nvim_command(string.format("chdir %s", currDir))
    api.nvim_buf_set_option(0, 'bufhidden',  'wipe')
    api.nvim_buf_set_option(0, 'buflisted',  false)
    api.nvim_buf_set_option(0, 'matchpairs',  '')
    api.nvim_command [[setl nonumber]]
    api.nvim_win_set_option(0, 'cursorline',  false)
    api.nvim_win_set_option(0, 'cursorcolumn',  false)
    api.nvim_win_set_option(0, 'relativenumber',  false)
    -- require 'tools'.simpleMRU()
    -- api.nvim_command [[:23]]
    -- api.nvim_buf_set_keymap(0, 'n', '<CR>', 'gf', {noremap = true})
    api.nvim_buf_set_option(0, 'modified', false)
    api.nvim_buf_set_option(0, 'modifiable', false)
  else
  end
end

local function core_options()
  local options = {
    hidden          = true;
    secure          = true;
    title           = true;
    lazyredraw      = true;
    splitright      = true;
    modeline        = false;
    ttimeout        = true;
    wildignorecase  = true;
    expandtab       = true;
    shiftround      = true;
    ignorecase      = true;
    smartcase       = true;
    undofile        = true;
    backup          = true;
    magic           = true;

    undolevels      = 1000;
    ttimeoutlen     = 20;
    shiftwidth      = 2;
    softtabstop     = 2;
    tabstop         = 2;
    synmaxcol       = 200;
    cmdheight       = 2;
    updatetime      = 200;
    conceallevel    = 2;
    cscopetagorder  = 0;
    cscopepathcomp  = 3;

    mouse           = "nv";
    foldopen        = "search";
    encoding        = "UTF-8";
    fileformat      = 'unix';
    diffopt         = "hiddenoff,iwhiteall,algorithm:patience";
    wildmode        = "full";
    grepprg         = [[rg\ --smart-case\ --vimgrep]];
    virtualedit     = "block";
    inccommand      = "split";
    cscopequickfix  = "s-,c-,d-,i-,t-,e-";
    path            = '.,,,**';
    completeopt     = {'menuone', 'noinsert', 'noselect', 'longest'};
    listchars       = {'tab:░░', 'trail:·', 'space:·', 'extends:»', 'precedes:«', 'nbsp:⣿'};
    complete        = {'.', 'w', 'b', 'u'};
    formatlistpat   = [[^\\s*\\[({]\\?\\([0-9]\\+\\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\\|^\\s*[-–+o*•]\\s\\+]];
    wildignore      = {'*/dist*/*','*/target/*','*/builds/*','tags','*/lib/*','*/locale/*','*/flow-typed/*','*/node_modules/*','*.png','*.PNG','*.jpg','*.jpeg','*.JPG','*.JPEG','*.pdf','*.exe','*.o','*.obj','*.dll','*.DS_Store','*.ttf','*.otf','*.woff','*.woff2','*.eot'};
    shortmess       = nvim.o.shortmess .. 's';
    undodir         = home .. "/.cache/Vim/undofile";
    backupdir       = home .. "/.cache/Vim/backup";
    directory       = home .. "/.cache/Vim/swap";

    -- UI OPTS
    termguicolors  = true;
    nowrap         = true;
    cursorline     = true;
    statusline     = "%#StatusLineModified#%{&mod?expand('%'):''}%*%{&mod?'':expand('%')}%<" .. "%=" .. "%<" .. "%{statusline#ReadOnly()}\\ %P";
    number         = true;
    pumblend       = 20;
    pumheight      = 15;
    scrolloff      = 1;
    sidescrolloff  = 5;
    display        = "lastline";
    guicursor      = "n:blinkwait60-blinkon175-blinkoff175,i-ci-ve:ver25";
  }

  for k, v in pairs(options) do
    if v == true or v == false then
      api.nvim_command('set ' .. k)
    elseif type(v) == 'table' then
      local values = ''
      for k2, v2 in pairs(v) do
        if k2 == 1 then
          values = values .. v2
        else
          values = values .. ',' .. v2
        end
      end
      api.nvim_command('set ' .. k .. '=' .. values)
    else
      api.nvim_command('set ' .. k .. '=' .. v)
    end
  end

  -- Globals
  vim.g.did_install_default_menus = 1
  vim.g.remove_whitespace = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_gzip = 1
  vim.g.loaded_python_provider = 1


  vim.g.python3_host_prog = is_windows and 'C:\\Users\\taylor.thompson\\AppData\\Local\\Programs\\Python\\Python36-32\\python.exe' or '/usr/local/bin/python3'

  if not is_windows then api.nvim_command('set shell=bash') end
  -- Global functions
  api.nvim_command [[
  function RemoveWhiteSpace() abort
    if (g:remove_whitespace)
      execute 'normal mz'
      %s/\s\+$//ge
      execute 'normal `z'
      endif
      endfunction
      ]]

      api.nvim_command [[
      function! MarkMargin () abort
      if exists('b:MarkMargin')
        call matchadd('ErrorMsg', '\%>'.b:MarkMargin.'v\s*\zs\S', 0)
        endif
        endfunction
        ]]

        -- abbrevs
        api.nvim_command [[ cnoreabbrev csa cs add ]]
        api.nvim_command [[ cnoreabbrev csf cs find ]]
        api.nvim_command [[ cnoreabbrev csk cs kill ]]
        api.nvim_command [[ cnoreabbrev csr cs reset ]]
        api.nvim_command [[ cnoreabbrev css cs show ]]
        api.nvim_command [[ cnoreabbrev csh cs help ]]

        -- Common mistakes
        api.nvim_command [[ iabbrev retrun  return ]]
        api.nvim_command [[ iabbrev pritn   print ]]
        api.nvim_command [[ iabbrev cosnt   const ]]
        api.nvim_command [[ iabbrev imoprt  import ]]
        api.nvim_command [[ iabbrev imprt   import ]]
        api.nvim_command [[ iabbrev iomprt  import ]]
        api.nvim_command [[ iabbrev improt  import ]]
        api.nvim_command [[ iabbrev slef    self ]]
        api.nvim_command [[ iabbrev teh     the ]]
        api.nvim_command [[ iabbrev hadnler handler ]]
        api.nvim_command [[ iabbrev bunlde  bundle ]]

        local autocmds = {
          load_core = {
            {"VimEnter",        "*",      [[lua splashscreen()]]};
            {"VimEnter",            "*", [[nested call tools#OpenQuickfix()]]};
            {"UIEnter",        "*",      [[lua require'ui']]};
            {"BufNewFile",      "*.html", "0r ~/vim/skeletons/skeleton.html"};
            {"BufNewFile",      "*.tsx",  "0r ~/vim/skeletons/skeleton.tsx"};
            {"BufNewFile",      "*.md",   "0r ~/vim/skeletons/skeleton.md"};
            {"VimLeavePre",     "*",      [[lua require'tools'.saveSession()]]};
            {"BufEnter",        "*",      [[call tools#loadDeps()]]};
            {"BufWritePre",     "*",      [[call RemoveWhiteSpace()]]};
            {"BufWritePre",     "*",      [[if !isdirectory(expand("<afile>:p:h"))|call mkdir(expand("<afile>:p:h"), "p")|endif]]};
            {"QuickFixCmdPost", "[^l]*", [[nested call tools#OpenQuickfix()]]};
            {"CursorHold,BufWritePost,BufReadPost,BufLeave", "*", [[if isdirectory(expand("<amatch>:h"))|let &swapfile = &modified|endif]]};
            {"FocusGained", "*", "checktime"};
          };
          ft = {
            {"FileType netrw au BufLeave netrw close"};
            {"FileType typescript,typescript.tsx,typescriptreact,javascript,javascript.jsx inoremap <C-l> console.log()<esc>i"};
            {"FileType typescript,typescript.tsx,typescriptreact,javascript,javascript.jsx inoremap <C-c> console.log(`%c${}`, 'color: ;')<esc>F{a"};
            {"FileType typescript,typescript.tsx,typescriptreact,javascript,javascript.jsx inoremap d<C-l> debugger"};
            {"FileType typescript,typescript.tsx,typescriptreact,javascript,javascript.jsx nnoremap <leader>i biimport {<esc>ea} from ''<esc>i"};
            {"FileType rust inoremap <C-l> println!(\"{}\",)<esc>i"};
            {"FileType dirvish nnoremap <buffer> <silent>D :lua require'tools'.deleteFile()<CR>"};
            {"FileType dirvish nnoremap <buffer> n :e %"};
            {"FileType dirvish nnoremap <buffer> r :lua require'tools'.renameFile()<CR>"};
            {"FileType netrw nnoremap <buffer> q :close<CR>"};
          };
          windows = {
            {"WinEnter", "*", "set number"};
            {"WinLeave", "*", "set nonumber"};
          };
          bufs = {
            {"BufReadPost quickfix nnoremap <buffer><silent>ra :ReplaceAll<CR>"};
            {"BufReadPost quickfix nnoremap <buffer>rq :ReplaceQF"};
            {"BufReadPost quickfix nnoremap <buffer>R  :Cfilter!<space>"};
            {"BufReadPost quickfix nnoremap <buffer>K  :Cfilter<space>"};
          };
        }
        nvim_create_augroups(autocmds)
      end

      local function create_commands()
        nvim.command [[command! Scratch lua require'tools'.makeScratch()]]
        nvim.command [[command! -nargs=1 -complete=buffer Bs :call tools#BufSel("<args>")]]
        nvim.command [[command! Diff call git#diff()]]
        nvim.command [[command! TDiff call git#threeWayDiff()]]
        nvim.command [[command! -range Gblame echo join(systemlist("git blame -L <line1>,<line2> " . expand('%')), "\n")]]
        nvim.command [[command! -nargs=1 -complete=command Redir silent call tools#redir(<q-args>)]]
        nvim.command [[command! -bang -nargs=+ ReplaceQF lua require'tools'.replaceQf(<f-args>)]]
        nvim.command [[command! -bang SearchBuffers lua require'tools'.grepBufs(<f-args>)]]
        nvim.command [[command! CSRefresh call symbols#CSRefreshAllConns()]]
        nvim.command [[command! PackagerInstall call tools#PackagerInit() | call packager#install()]]
        nvim.command [[command! -bang PackagerUpdate call tools#PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })]]
        nvim.command [[command! PackagerClean call tools#PackagerInit() | call packager#clean()]]
        nvim.command [[command! ShowConsts match ConstStrings '\<\([A-Z]\{2,}_\?\)\+\>']]
        nvim.command [[command! CSBuild call symbols#buildCscopeFiles()]]
        nvim.command [[command! PackagerStatus call tools#PackagerInit() | call packager#status()]]
        nvim.command [[command! MarkMargin call MarkMargin()]]
      end

      local modules_folder = 'modules' .. file_separator
      api.nvim_command(string.format('runtime! %s*', modules_folder))

      core_options()
      create_commands()
