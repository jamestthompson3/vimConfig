function! QFHistory(goNewer)
  " Get dictionary of properties of the current window
  let wininfo = filter(getwininfo(), {i,v -> v.winnr == winnr()})[0]
  let isloc = wininfo.loclist
  " Build the command: one of colder/cnewer/lolder/lnewer
  let cmd = (isloc ? 'l' : 'c') . (a:goNewer ? 'newer' : 'older')
  try | execute cmd | catch | endtry
endfunction

" open the quickfix window if there are valid errors
function! quickfixed#OpenQuickfix()
    if get(g:, 'qf_auto_open_quickfix', 1)
        " get user-defined maximum height
        let max_height = get(g:, 'qf_max_height', 10) < 1 ? 10 : get(g:, 'qf_max_height', 10)
        execute get(g:, "qf_auto_resize", 1) ? 'cclose|' . min([ max_height, len(getqflist()) ]) . 'cwindow' : 'cwindow'
    endif
endfunction
