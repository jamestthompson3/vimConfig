require 'nvim_utils'
local is_windows = vim.loop.os_uname().version:match("Windows")
local nvim_options = setmetatable({}, {
  __index = function(_, k)
    return vim.api.nvim_get_option(k)
  end;
  __newindex = function(_, k, v)
    return vim.api.nvim_set_option(k, v)
  end
});

local M = {}

function M.core_options()
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
    wildmode        = "list:longest,full";
    grepprg         = [[rg\ --smart-case\ --vimgrep]];
    virtualedit     = "block";
    inccommand      = "split";
    cscopequickfix  = "s-,c-,d-,i-,t-,e-";
    path            = nvim_options.path .. ',' .. vim.api.nvim_call_function('getenv', { 'PWD' });
    completeopt     = {'menuone', 'noinsert', 'noselect', 'longest'};
    complete        = {'.', 'w', 'b', 'u'};
    formatlistpat   = [[^\\s*\\[({]\\?\\([0-9]\\+\\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\\|^\\s*[-–+o*•]\\s\\+]];

    -- UI OPTS
    termguicolors  = true;
    wrap           = false;
    cursorline     = true;
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
      vim.api.nvim_command('set ' .. k)
    elseif type(v) == 'table' then
      local values = ''
      for k2, v2 in pairs(v) do
        if k2 == 1 then
          values = values .. v2
        else
          values = values .. ',' .. v2
        end
      end
      vim.api.nvim_command('set ' .. k .. '=' .. values)
    else
      vim.api.nvim_command('set ' .. k .. '=' .. v)
    end
  end

  -- Globals
  vim.g.did_install_default_menus = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_gzip = 1
  vim.g.loaded_python_provider = 1


    vim.g.python3_host_prog = is_windows and 'C:\\Users\\taylor.thompson\\AppData\\Local\\Programs\\Python\\Python36-32\\python.exe' or '/usr/local/bin/python3'

  local autocmds = {
    load_core = {
      {"VimEnter",       "*",      [[call SplashScreen()]]};
      {"BufNewFile",      "*.html", "0r ~/vim/skeletons/skeleton.html"};
      {"BufNewFile",      "*.tsx",  "0r ~/vim/skeletons/skeleton.tsx"};
      {"BufNewFile",     "*.md",   "0r ~/vim/skeletons/skeleton.md"};
      {"WinNew",         "*",      [[call sessions#saveSession()]]};
      {"VimLeavePre",     "*",      [[call sessions#saveSession()]]};
      {"BufAdd",          "*",      [[call tools#loadDeps()]]};
      {"SessionLoadPost", "*",      [[call tools#loadDeps()]]};
      {"QuickFixCmdPost", "[^l]*", [[nested call tools#OpenQuickfix()]]};
      {"VimEnter",            "*", [[nested call tools#OpenQuickfix()]]};
    };
    ft = {
      {"FileType netrw au BufLeave netrw close"};
    };
    windows = {
      {"WinEnter", "*", "set number"};
      {"WinLeave", "*", "set nonumber"};
    };
  }
  nvim_create_augroups(autocmds)
end

function M.create_commands()
  nvim.command [[command! Scratch call tools#makeScratch()]]
  nvim.command [[command! -nargs=1 -complete=buffer Bs :call tools#BufSel("<args>")]]
  nvim.command [[command! Diff call git#diff()]]
  nvim.command [[command! TDiff call git#threeWayDiff()]]
  nvim.command [[command! -range Gblame echo join(systemlist("git blame -L <line1>,<line2> " . expand('%')), "\n")]]
  nvim.command [[command! -nargs=1 -complete=command Redir silent call tools#redir(<q-args>)]]
  nvim.command [[command! -bang -nargs=+ ReplaceQF call tools#Replace_qf(<f-args>)]]
  nvim.command [[command! -bang SearchBuffers call tools#GrepBufs()]]
  nvim.command [[command! CSRefresh call symbols#CSRefreshAllConns()]]
  nvim.command [[command! PackagerInstall call tools#PackagerInit() | call packager#install()]]
  nvim.command [[command! -bang PackagerUpdate call tools#PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })]]
  nvim.command [[command! PackagerClean call tools#PackagerInit() | call packager#clean()]]
  nvim.command [[command! ShowConsts match ConstStrings '\<\([A-Z]\{2,}_\?\)\+\>']]
  nvim.command [[command! CSBuild call symbols#buildCscopeFiles()]]
  nvim.command [[command! PackagerStatus call tools#PackagerInit() | call packager#status()]]
  nvim.command [[command! MarkMargin call MarkMargin()]]
end

local file_separator = is_windows and '\\' or '/'
local modules_folder = 'modules' .. file_separator
vim.g.sessionPath = '~'.. file_separator .. 'sessions' .. file_separator
vim.api.nvim_command(string.format('runtime! %s*', modules_folder))

M.core_options()
M.create_commands()
