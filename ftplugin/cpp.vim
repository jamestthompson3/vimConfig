let b:source_ft = ['h', 'hpp']
let b:ale_linters = ['clang', 'clangd']

nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>
set define=^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)
packadd tagbar
