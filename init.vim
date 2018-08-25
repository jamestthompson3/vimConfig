set encoding=utf8
scriptencoding utf-8
set fileencoding=utf8
set fileformat=unix

" Create function to manage things in a semi-sane way
if has('win16') || has('win32') || has('win64')
 let g:file_separator = '\\'
else
 let g:file_separator = '/'
endif

let g:modules_folder = 'modules' . g:file_separator

" Load plugins
call LoadPackages#Load()

" Load custom modules
function! LoadCustomModule( name )
  let l:script = g:modules_folder .  a:name . '.vim'
  exec ':runtime ' . l:script
endfunction

call LoadCustomModule( 'core' )
call LoadCustomModule( 'ui' )
call LoadCustomModule( 'bindings' )
call LoadCustomModule( 'tools' )
call LoadCustomModule( 'linting_lsp' )

" Org tools
" let g:org_todo_keywords = [['TODO(t)', '|', 'DONE(d)'],
"       \ ['REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)', '|', 'FIXED(f)'],
"       \ ['CANCELED(c)']]

