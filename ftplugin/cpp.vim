let b:source_ft = ['h', 'hpp']

nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>
set define=^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)
