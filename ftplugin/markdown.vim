match Callout '@\w\+\.\?\w\+'
"TODO somehow broken in lsp popups
let g:markdown_fenced_languages = ['html', 'typescript', 'javascript', 'js=javascript', 'bash=sh', 'rust']
packadd vim-markdown

nnoremap j gj
nnoremap k gk

function s:composer() abort
  packadd vim-wordy
  setlocal wrap
  setlocal linebreak
  setlocal spell
  setlocal textwidth=0
  if exists('g:set_writerline')
    finish
  else
    set statusline+=\ %{wordcount().words}\ words
    let g:set_writerline = 1
  endif
endfunction

command! Compose :call s:composer()
