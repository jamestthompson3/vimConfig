local iabbrev = require("tt.nvim_utils").vim_util.iabbrev
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
iabbrev("sapn", "span")
iabbrev("teh", "the")
iabbrev("tehn", "then")
iabbrev("hadnler", "handler")
iabbrev("bunlde", "bundle")

api.nvim_command([[command! -nargs=+ -complete=dir -bar SearchProject silent grep! <q-args>]])
api.nvim_command([[command! -nargs=1 -complete=buffer Bs :call tools#BufSel("<args>")]])
api.nvim_command([[command! Diff lua require'tt.git'.diff()]])
api.nvim_command([[command! Changed lua require'tt.git'.changedFiles()]])
api.nvim_command([[command! Ftc let @+=expand("%")]]) -- filename to clipboard
api.nvim_command([[command! Restore lua require'tt.tools'.restoreFile() ]])
api.nvim_command([[command! -nargs=1 -complete=command Redir silent call tools#redir(<q-args>)]])
api.nvim_command([[command! -bang SearchBuffers lua require'tt.tools'.grepBufs(<q-args>)]])
api.nvim_command([[command! Cheat lua require'tt.tools'.cheatsheet()]])
api.nvim_command([[command! WikiMode lua require'tt.tools'.setupWiki()]])

-- Global Vim functions
api.nvim_command([[
function! HLNext (blinktime) abort
  let target_pat = '\c\%#'.@/
  let ring = matchadd('DiffDelete', target_pat, 101)
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
