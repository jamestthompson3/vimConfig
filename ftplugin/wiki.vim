packadd vimwiki
packadd vim-speeddating
let b:localleader = "\\"
iab <expr> dtss strftime("%H:%M")
iab <expr> dateheader strftime("%Y %b %d")
" highlight people / things with @
match Todo '@\w\+'
set foldmethod=syntax
