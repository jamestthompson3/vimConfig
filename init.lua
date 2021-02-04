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
local home = os.getenv("HOME")

vim.g.mapleader = " "

api.nvim_command [[colorscheme ghost_mono]]

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
set.backup          = true
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
set.encoding        = "UTF-8"
set.fileformat      = 'unix'
set.diffopt         = "hiddenoff,iwhiteall,algorithm:patience"
set.nrformats       = "bin,hex,alpha"
set.wildmode        = "full"
set.grepprg         = "rg --smart-case --vimgrep --block-buffered"
set.virtualedit     = "block"
set.inccommand      = "split"
set.cscopequickfix  = "s-,c-,d-,i-,t-,e-"
set.path            = '.,,,**'
-- set.tabline         = gitBranch()
set.showtabline     = 0
set.completeopt     = 'menuone,noinsert,noselect,longest'
set.listchars       = 'tab:░░,trail:·,space:·,extends:»,precedes:«,nbsp:⣿'
set.complete        = '.,w,b,u'
set.formatlistpat   = "^\\s*\\[({]\\?\\([0-9]\\+\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\|^\\s*[-–+o*•]\\s\\+"
set.wildignore      = '*/dist*/*,*/target/*,*/builds/*,*/flow-typed/*,*.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG,*.pdf,*.exe,*.o,*.obj,*.dll,*.DS_Store,*.ttf,*.otf,*.woff,*.woff2,*.eot'
set.shortmess       = vim.o.shortmess .. 's'
set.undodir         = home .. "/.cache/Vim/undofile"
set.backupdir       = home .. "/.cache/Vim/backup"
set.directory       = home .. "/.cache/Vim/swap"

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
set.display        = "lastline"
set.guicursor      = "n:blinkwait60-blinkon175-blinkoff175,i-ci-ve:ver25"

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


local function core_options()
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

        api.nvim_command [[
        function! AS_HandleSwapfile (filename, swapname)
        " if swapfile is older than file itself, just get rid of it
        if getftime(v:swapname) < getftime(a:filename)
          call delete(v:swapname)
          let v:swapchoice = 'e'
          endif
          endfunction
          ]]



          -- abbrevs
          api.nvim_command [[ cnoreabbrev csa cs add ]]
          api.nvim_command [[ cnoreabbrev csf cs find ]]
          api.nvim_command [[ cnoreabbrev csk cs kill ]]
          api.nvim_command [[ cnoreabbrev csr cs reset ]]
          -- api.nvim_command [[ cnoreabbrev css cs show ]]
          api.nvim_command [[ cnoreabbrev csh cs help ]]

          -- Common mistakes
          api.nvim_command [[iabbrev retrun  return]]
          api.nvim_command [[iabbrev pritn   print]]
          api.nvim_command [[iabbrev cosnt   const]]
          api.nvim_command [[iabbrev imoprt  import]]
          api.nvim_command [[iabbrev imprt   import]]
          api.nvim_command [[iabbrev iomprt  import]]
          api.nvim_command [[iabbrev improt  import]]
          api.nvim_command [[iabbrev slef    self]]
          api.nvim_command [[iabbrev teh     the]]
          api.nvim_command [[iabbrev tehn     then]]
          api.nvim_command [[iabbrev hadnler handler]]
          api.nvim_command [[iabbrev bunlde  bundle]]

          local autocmds = {
            load_core = {
              {"VimEnter",        "*",      [[lua splashscreen()]]};
              {"VimEnter",        "*",      [[nested lua require'tt.tools'.openQuickfix()]]};
              {"SwapExists",      "*",      "call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)"};
              {"TextYankPost",    "*",      [[silent! lua require'vim.highlight'.on_yank()]]};
              {"BufNewFile",      "*.html", "0r ~/vim/skeletons/skeleton.html"};
              {"BufNewFile",      "*.tsx",  "0r ~/vim/skeletons/skeleton.tsx"};
              {"BufNewFile",      "*.md",   "0r ~/vim/skeletons/skeleton.md"};
              {"VimLeavePre",     "*",      [[lua require'tt.tools'.saveSession()]]};
              -- {"TermClose",       "*",      [[lua vim.api.nvim_input("i<esc>") ]]};
              {"TermEnter",       "*",      "set nonumber"};
              {"UIEnter",          "*",     [[lua require'tt.tools'.configurePlugins()]]};
              {"BufEnter",        "*",      [[lua require'completion'.on_attach()]]};
              {"BufWritePre",     "*",      [[call RemoveWhiteSpace()]]};
              {"BufWritePre",     "*",      [[if !isdirectory(expand("<afile>:p:h"))|call mkdir(expand("<afile>:p:h"), "p")|endif]]};
              {"QuickFixCmdPost", "[^l]*", [[nested lua require'tt.tools'.openQuickfix()]]};
              {"CursorHold,BufWritePost,BufReadPost,BufLeave", "*", [[if isdirectory(expand("<amatch>:h"))|let &swapfile = &modified|endif]]};
              -- { "FileType,BufWinEnter,BufReadPost,BufWritePost,BufEnter,WinEnter,FileChangedShellPost,VimResized" , "*", [[lua vim.wo.statusline = "%!SL()"]] };
              -- {"WinLeave", "*", [[lua vim.wo.statusline = "%f"]]};
              {"CursorMoved",        "*",     [[lua require'tt.tools'.clearBlameVirtText()]]};
              {"CursorMovedI",        "*",     [[lua require'tt.tools'.clearBlameVirtText()]]};
              {"FocusGained,CursorMoved,CursorMovedI", "*", "checktime"};
            };
            ft = {
              {"FileType netrw au BufLeave netrw close"};
              {"FileType lua inoremap <C-l> log()<esc>i"};
              {"FileType typescript,typescript.tsx,typescriptreact,javascriptreact,javascript,javascript.jsx nnoremap <leader>i biimport {<esc>ea} from ''<esc>i"};
              {"FileType dirvish nnoremap <buffer> <silent>D :lua require'tt.tools'.deleteFile()<CR>"};
              {"FileType dirvish nnoremap <buffer> n :e %"};
              {"FileType dirvish nnoremap <buffer> r :lua require'tt.tools'.renameFile()<CR>"};
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
              {"BufReadPost",         "*.fugitiveblame", "set ft=fugitiveblame"};
            };
            ft_detect = {
              { "BufRead,BufNewFile",  "*.nginx", "set ft=nginx"};
              { "BufRead,BufNewFile", "nginx*.conf", "set ft=nginx"};
              { "BufRead,BufNewFile", "*nginx.conf","set ft=nginx"};
              { "BufRead,BufNewFile", "*/etc/nginx/*","set ft=nginx"};
              { "BufRead,BufNewFile", "*/usr/local/nginx/conf/*","set ft=nginx"};
              { "BufRead,BufNewFile", "*/nginx/*.conf","set ft=nginx"};
              { "BufNewFile,BufRead", "*.bat,*.sys", "set ft=dosbatch"};
              { "BufNewFile,BufRead", "*.mm,*.m", "set ft=objc"};
              { "BufNewFile,BufRead", "*.h,*.m,*.mm","set tags+=~/global-objc-tags"};
              { "BufNewFile,BufRead", "*.tsx", "setlocal commentstring=//%s"};
              { "BufNewFile,BufRead", "*.svelte", "setfiletype html"};
              { "BufNewFile,BufRead", "*.eslintrc,*.babelrc,*.prettierrc,*.huskyrc", "set ft=json"};
              { "BufNewFile,BufRead", "*.pcss", "set ft=css"};
              { "BufNewFile,BufRead", "*.wiki", "set ft=wiki"};
              { "BufRead,BufNewFile", "[Dd]ockerfile","set ft=Dockerfile"};
              { "BufRead,BufNewFile", "Dockerfile*","set ft=Dockerfile"};
              { "BufRead,BufNewFile", "[Dd]ockerfile.vim" ,"set ft=vim"};
              { "BufRead,BufNewFile", "*.dock", "set ft=Dockerfile"};
              { "BufRead,BufNewFile", "*.[Dd]ockerfile","set ft=Dockerfile"};
            };
          }
          nvim_create_augroups(autocmds)
        end

        local function create_commands()
          -- nvim.command [[command! -nargs=+ -complete=dir -bar SearchProject lua require'tools'.asyncGrep(<q-args>)]]
          nvim.command [[command! -nargs=+ -complete=dir -bar SearchProject silent grep! <q-args>]]
          nvim.command [[command! Scratch lua require'tools'.makeScratch()]]
          nvim.command [[command! -nargs=1 -complete=file_in_path Find lua require'tt.tools'.fastFind(<f-args>) ]]
          nvim.command [[command! -nargs=1 -complete=buffer Bs :call tools#BufSel("<args>")]]
          nvim.command [[command! Diff call git#diff()]]
          nvim.command [[command! TDiff call git#threeWayDiff()]]
          nvim.command [[command! Gblame lua require'tt.tools'.blameVirtText() ]]
          nvim.command [[command! -nargs=1 -complete=command Redir silent call tools#redir(<q-args>)]]
          nvim.command [[command! -bang -nargs=+ ReplaceQF lua require'tt.tools'.replaceQf(<f-args>)]]
          nvim.command [[command! -bang SearchBuffers lua require'tt.tools'.grepBufs(<q-args>)]]
          nvim.command [[command! CSRefresh call symbols#CSRefreshAllConns()]]
          nvim.command [[command! ShowConsts match ConstStrings '\<\([A-Z]\{2,}_\?\)\+\>']]
          nvim.command [[command! CSBuild call symbols#buildCscopeFiles()]]
          nvim.command [[command! MarkMargin call MarkMargin()]]
          nvim.command [[command! -nargs=+ ListFiles lua require'tt.tools'.listFiles(<q-args>)]]
        end

        local modules_folder = 'modules' .. file_separator
        api.nvim_command(string.format('runtime! %s*', modules_folder))

        core_options()
        create_commands()

        require('tt.globals')
        require('tt.plugins')
        require('tt.mappings')
