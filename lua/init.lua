require 'nvim_utils'

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
    hidden          = true,
    secure          = true,
    title           = true,
    lazyredraw      = true,
    splitright      = true,
    modeline        = false,
    ttimeout        = true,
    wildignorecase  = true,
    expandtab       = true,
    shiftround      = true,
    ignorecase      = true,
    smartcase       = true,
    undofile        = true,
    backup          = true,
    magic           = true,

    undolevels      = 1000,
    ttimeoutlen     = 20,
    shiftwidth      = 2,
    softtabstop     = 2,
    tabstop         = 2,
    synmaxcol       = 200,
    cmdheight       = 2,
    updatetime      = 200,
    conceallevel    = 2,
    cscopetagorder  = 0,
    cscopepathcomp  = 3,

    mouse           = "nv",
    foldopen        = "search",
    diffopt         = "hiddenoff,iwhiteall,algorithm:patience",
    wildmode        = "list:longest,full",
    grepprg         = "rg --smart-case --vimgrep",
    virtualedit     = "block",
    inccommand      = "split",
    cscopequickfix = "s-,c-,d-,i-,t-,e-",

    -- UI OPTS
    termguicolors  = true,
    wrap           = false,
    cursorline     = true,
    number         = true,
    pumblend       = 20,
    pumheight      = 15,
    scrolloff      = 1,
    sidescrolloff  = 5,
    display        = "lastline",
    guicursor      = "n:blinkwait60-blinkon175-blinkoff175,i-ci-ve:ver25",
  }
  for k, v in pairs(options) do nvim_options[k] = v end

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

function M.plugin_globals()
  vim.g.mucomplete_buffer_relative_paths = 1
end


return M
