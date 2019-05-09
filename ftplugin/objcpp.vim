set path+=/System/Library/Frameworks/Foundation.framework/Headers/**
let b:source_ft = 'mm'
let b:ale_linters = ['clang', 'clangd']

set define=^\(#\s*define\|[a-z]*\s*const\s*[a-z]*\)
