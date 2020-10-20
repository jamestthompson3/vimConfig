set path+=/System/Library/Frameworks/Foundation.framework/Headers/**
let b:source_ft = ['m', 'mm']
nnoremap <silent><leader>h :call tools#switchSourceHeader()<CR>
let b:ale_linters = ['clang', 'clang']
let b:devURL = " 'https://developer.apple.com/search/?lang=objc&q="

set define=^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)
