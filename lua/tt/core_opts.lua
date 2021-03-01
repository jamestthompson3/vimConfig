require 'tt.nvim_utils'
local api = vim.api

if not is_windows then api.nvim_command('set shell=bash') end
vim.cmd [[packadd cfilter]]

-- abbrevs
nvim.command [[ cnoreabbrev csa cs add ]]
nvim.command [[ cnoreabbrev csf cs find ]]
nvim.command [[ cnoreabbrev csk cs kill ]]
nvim.command [[ cnoreabbrev csr cs reset ]]
-- api.nvim_command [[ cnoreabbrev css cs show ]]
nvim.command [[ cnoreabbrev csh cs help ]]
-- Common mistakes
nvim.command [[iabbrev retrun  return]]
nvim.command [[iabbrev pritn   print]]
nvim.command [[iabbrev cosnt   const]]
nvim.command [[iabbrev imoprt  import]]
nvim.command [[iabbrev imprt   import]]
nvim.command [[iabbrev iomprt  import]]
nvim.command [[iabbrev improt  import]]
nvim.command [[iabbrev slef    self]]
nvim.command [[iabbrev teh     the]]
nvim.command [[iabbrev tehn    then]]
nvim.command [[iabbrev hadnler handler]]
nvim.command [[iabbrev bunlde  bundle]]

nvim.command [[command! -nargs=+ -complete=dir -bar SearchProject lua require'tt.tools'.asyncGrep(<q-args>)]]
-- nvim.command [[command! -nargs=+ -complete=dir -bar SearchProject silent grep! <q-args>]]
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
nvim.command [[command! MarkMargin lua require'tt.tools'.markMargin()]]
nvim.command [[command! Symbols lua require'telescope.builtin'.lsp_document_symbols()]]
nvim.command [[command! -nargs=+ ListFiles lua require'tt.tools'.listFiles(<q-args>)]]

-- Global Vim functions
nvim.command [[
function! HLNext (blinktime) abort
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

function! AS_HandleSwapfile (filename, swapname)
 " if swapfile is older than file itself, just get rid of it
 if getftime(v:swapname) < getftime(a:filename)
   call delete(v:swapname)
   let v:swapchoice = 'e'
 endif
endfunction
]]
