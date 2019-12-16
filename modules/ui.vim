scriptencoding utf-8

set listchars=
set listchars+=tab:░\
set listchars+=trail:·
set listchars+=space:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set statusline+=%#StatusLineModified#%{&mod?expand('%'):''}%*%{&mod?'':expand('%')}%<
set statusline+=%=
set statusline+=%<
set statusline+=%#MatchParen#%{statusline#LineNoIndicator()}%*\ %{statusline#ReadOnly()}
