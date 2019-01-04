set encoding=utf8
scriptencoding utf-8
set fileencoding=utf8
set fileformat=unix

" Disable vim plugins
let g:did_install_default_menus = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_gzip = 1

let g:isOni = exists('g:gui_oni')
" Create function to manage thing in a semi-sane way
let g:isWindows = has('win16') || has('win32') || has('win64')
if g:isWindows
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

