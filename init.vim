set encoding=utf8
scriptencoding utf-8
set fileencoding=utf8
set fileformat=unix

let g:isOni = exists('g:gui_oni')
" Create function to manage thing in a semi-sane way
let g:isWindows = has('win16') || has('win32') || has('win64')
if g:isWindows
 let g:file_separator = '\\'
else
 let g:file_separator = '/'
endif

let g:modules_folder = 'modules' . g:file_separator

" set globals before packes are loaded
let g:ale_completion_enabled = 1
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

