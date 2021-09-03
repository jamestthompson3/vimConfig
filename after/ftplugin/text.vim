setlocal wrap
setlocal linebreak
setlocal spell
setlocal textwidth=120

syntax region CodeFence start=+```\w\++ end=+```+ contains=@NoSpell
syntax region CodeBlock start=+`\w\++ end=+`+ contains=@NoSpell
syntax match UrlNoSpell /\w\+:\/\/[^[:space:]]\+/ contains=@NoSpell

nnoremap j gj
nnoremap k gk

if exists('g:set_writerline')
  finish
else
  set statusline+=\ %{wordcount().words}\ words
  let g:set_writerline = 1
endif
