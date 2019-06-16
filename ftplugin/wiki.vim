let b:localleader = "\\"
iab <expr> dtss strftime("%H:%M")
iab <expr> dateheader strftime("%Y %b %d")
" highlight people / things with @
match Callout '@\w\+\.\?\w\+'
setlocal foldmethod=syntax
setlocal textwidth=120
setlocal wrap

" Jira stuff
command! JIRAIssues call jira#getIssues()
command! -range -nargs=0 JIRATransition call jira#transitionIssue()
