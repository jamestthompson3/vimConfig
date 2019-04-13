set path+=/System/Library/Frameworks/Foundation.framework/Headers/**
let b:source_ft = 'm'
nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>
let b:ale_linters = ['clang', 'clang']
