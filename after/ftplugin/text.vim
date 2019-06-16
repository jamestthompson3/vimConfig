packadd vim-wordy
setlocal wrap
setlocal linebreak
setlocal spell
setlocal textwidth=0

syntax region CodeFence start=+```\w\++ end=+```+ contains=@NoSpell
syntax region CodeBlock start=+`\w\++ end=+`+ contains=@NoSpell
syntax match UrlNoSpell /\w\+:\/\/[^[:space:]]\+/ contains=@NoSpell

nnoremap j gj
nnoremap k gk

set statusline+=\ %{wordcount().words}\ words
