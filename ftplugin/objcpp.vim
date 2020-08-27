set path+=/System/Library/Frameworks/Foundation.framework/Headers/**
let b:source_ft = ['mm', 'm']
let b:ale_linters = ['clang', 'clangd']

nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>
set define=^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)
