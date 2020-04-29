echom "Loaded python"
packadd jedi-vim
let b:ale_linters = ['flake8', 'pylint']
" set omnifunc=python3complete#Complete
set list
let python_highlight_all = 1
let g:jedi#popup_on_dot = 1

" let g:mucomplete#chains.python = ['omni', 'tags', 'keyn', 'keyp', 'c-p', 'c-n', 'file','path']

hi link pythonStatement Keyword
