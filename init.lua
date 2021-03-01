vim.g.loaded_matchparen = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_python_provider = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchit = 1

require 'tt.nvim_utils'
local set = vim.o
local api = vim.api
local fn  = vim.fn
local home = os.getenv("HOME")

vim.g.mapleader = " "

-- statusline fun
api.nvim_command [[
function! SL() abort
return "%#" . luaeval('require("tt.tools").statuslineHighlight()') . "#" . luaeval('require("tt.tools").statuslineIcon()') . "%#StatusLineModified#%{&mod?expand('%:p:t'):''}%*%{&mod?'':expand('%:p:t')}%<" .. "%=" .. "%<" .. "%r %L"
endfunction
]]

set.hidden          = true
set.secure          = true
set.title           = true
set.lazyredraw      = true
set.splitright      = true
set.modeline        = false
set.ttimeout        = true
set.wildignorecase  = true
set.expandtab       = true
set.shiftround      = true
set.ignorecase      = true
set.smartcase       = true
set.undofile        = true
set.magic           = true
set.number          = true
set.tags            = "" -- let gutentags handle this

set.undolevels      = 1000
set.ttimeoutlen     = 20
set.shiftwidth      = 2
set.softtabstop     = 2
set.tabstop         = 2
set.synmaxcol       = 200
set.cmdheight       = 2
set.updatetime      = 200
set.conceallevel    = 2
set.cscopetagorder  = 0
set.cscopepathcomp  = 3
set.showbreak       = string.rep(' ', 3) -- Make it so that long lines wrap smartly

set.mouse           = "nv"
set.foldopen        = "search"
set.fileformat      = 'unix'
set.diffopt         = "hiddenoff,iwhiteall,algorithm:patience"
set.nrformats       = "bin,hex,alpha"
set.grepprg         = "rg --smart-case --vimgrep --block-buffered"
set.virtualedit     = "block"
set.inccommand      = "split"
set.cscopequickfix  = "s-,c-,d-,i-,t-,e-"
set.path            = '.,,,**'
set.completeopt     = 'menuone,noselect'
set.listchars       = 'tab:░░,trail:·,space:·,extends:»,precedes:«,nbsp:⣿'
set.formatlistpat   = "^\\s*\\[({]\\?\\([0-9]\\+\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\|^\\s*[-–+o*•]\\s\\+"
set.foldlevelstart  = 99
set.foldmethod      = "syntax"
set.wildignore      = '*/dist*/*,*/target/*,*/builds/*,*/node_modules/*,*/flow-typed/*,*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf,*.exe,*.o,*.obj,*.dll,*.DS_Store,*.ttf,*.otf,*.woff,*.woff2,*.eot'
set.shortmess       = vim.o.shortmess .. 's'
set.undodir         = home .. "/.cache/Vim/undofile"

-- UI OPTS
set.termguicolors  = true
set.wrap           = false
set.cursorline     = true
set.fillchars      = "stlnc:»,vert:║,fold:·"
set.number         = true
set.pumblend       = 20
set.pumheight      = 15
set.scrolloff      = 1
set.sidescrolloff  = 5
set.guicursor      = "n:blinkwait60-blinkon175-blinkoff175,i-ci-ve:ver25"



function splashscreen()
  local curr_buf = api.nvim_get_current_buf()
  local args = vim.fn.argc()
  local offset = api.nvim_buf_get_offset(curr_buf, 1)
  local currDir = os.getenv('PWD')
  if offset == -1 and args == 0 then
    api.nvim_create_buf(false, true)
    api.nvim_command [[ silent! r ~/vim/skeletons/start.screen ]]
    api.nvim_command(string.format("chdir %s", currDir))
    vim.bo[0].bufhidden='wipe'
    vim.bo[0].buflisted=false
    vim.bo[0].matchpairs=''
    api.nvim_command [[setl nonumber]]
    api.nvim_command [[setl nocursorline]]
    vim.wo[0].cursorcolumn=false
    require('tt.tools').simpleMRU()
    api.nvim_command [[:34]]
    api.nvim_buf_set_keymap(0, 'n', '<CR>', 'gf', {noremap = true})
    vim.bo[0].modified=false
    vim.bo[0].modifiable=false
  else
  end
end



vim.fn['tools#loadCscope']()
require('tt.core_opts')
require('tt.autocmds')
require('tt.globals')
require('tt.plugins')
require('tt.mappings')

nvim.command [[colorscheme ghost_mono]]
require'tt.tools'.setCustomGroups()
