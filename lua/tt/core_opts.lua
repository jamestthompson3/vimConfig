require("tt.nvim_utils")
local api = vim.api

if not is_windows then
	api.nvim_command("set shell=bash")
end
api.nvim_command([[packadd cfilter]])

-- abbrevs
-- Common mistakes
iabbrev("retrun", "return")
iabbrev("pritn", "print")
iabbrev("cosnt", "const")
iabbrev("imoprt", "import")
iabbrev("imprt", "import")
iabbrev("iomprt", "import")
iabbrev("improt", "import")
iabbrev("slef", "self")
iabbrev("teh", "the")
iabbrev("tehn", "then")
iabbrev("hadnler", "handler")
iabbrev("bunlde", "bundle")

-- FIXME this is flakey :(
-- nvim.command([[command! -nargs=+ -complete=dir -bar SearchProject lua require'tt.tools'.asyncGrep(<q-args>)]])
api.nvim_command([[command! -nargs=+ -complete=dir -bar SearchProject silent grep! <q-args>]])
api.nvim_command([[command! Scratch lua require'tt.tools'.makeScratch()]])
api.nvim_command([[command! -nargs=1 -complete=buffer Bs :call tools#BufSel("<args>")]])
api.nvim_command([[command! Diff call git#diff()]])
api.nvim_command([[command! TDiff call git#threeWayDiff()]])
api.nvim_command([[command! Ftc let @+=expand("%")]]) -- filename to clipboard
api.nvim_command([[command! Gblame lua require'tt.tools'.blameVirtText() ]])
api.nvim_command([[command! Restore lua require'tt.tools'.restoreFile() ]])
api.nvim_command([[command! -nargs=1 -complete=command Redir silent call tools#redir(<q-args>)]])
api.nvim_command([[command! -bang SearchBuffers lua require'tt.tools'.grepBufs(<q-args>)]])
api.nvim_command([[command! ShowConsts match ConstStrings '\<\([A-Z]\{2,}_\?\)\+\>']])
api.nvim_command([[command! MarkMargin lua require'tt.tools'.markMargin()]])
api.nvim_command([[command! Symbols lua require'telescope.builtin'.lsp_document_symbols()]])
api.nvim_command([[command! Cheat lua require'tt.tools'.cheatsheet()]])

-- Global Vim functions
api.nvim_command([[
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
]])
