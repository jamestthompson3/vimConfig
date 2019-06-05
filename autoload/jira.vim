function! jira#getIssues() abort
  execute 'r !jira i'
  execute '%s/\e\[[0-9;]\+[mK]//g'
endfunction

function! jira#transitionIssue() abort
  let l:selection = s:get_visual_selection()
  execute 'copen'
  execute 'term jira i '.l:selection.' -t'
endfunction

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

hi Green guibg=#77ff77 guifg=#000000
syn match Todo 'To\ Do'
syn match Identifier 'In\ Progress'
syn match Green '?\w\+\-[0-9]\+'

" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call tools#CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call tools#CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call tools#CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call tools#CombineSelection(<line1>, <line2>, '0336')
