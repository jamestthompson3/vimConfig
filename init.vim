" Plugins
set encoding=utf-8
set fileencoding=utf-8
" Create function to manage things in a semi-sane way
if has('win16') || has('win32') || has('win64')
 let g:file_separator = '\\'
else
 let g:file_separator = '/'
endif

let g:modules_folder = 'modules' . file_separator

" Load plugins
call LoadPackages#Load()

function! LoadCustomModule( name )
  let script = g:modules_folder .  a:name . ".vim"
 " echom "Now loading " . a:name
  exec ":runtime " . script
endfunction

" Load custom modules
call LoadCustomModule( 'core' )
call LoadCustomModule( 'ui' )
call LoadCustomModule( 'bindings' )
call LoadCustomModule( 'tools' )
call LoadCustomModule( join(['lang','javascript'], g:file_separator) )


" matchup settings
let g:matchup_transmute_enabled = 1
let g:matchup_motion_enabled = 0
let g:matchup_matchparen_deferred = 1
let g:matchup_match_paren_timeout = 100
" completion
let g:asyncomplete_remove_duplicates = 1
" Faster leaderf
let g:Lf_WildIgnore = {'dir': ['lib','build', 'node_modules'], 'file': []}
" Org tools
" let g:org_todo_keywords = [['TODO(t)', '|', 'DONE(d)'],
"       \ ['REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)', '|', 'FIXED(f)'],
"       \ ['CANCELED(c)']]
" Linting
let g:ale_linters = {
\   'javascript': ['eslint', 'flow' ],
\   'python': ['flake8', 'pylint'],
\   'rust': ['rls', 'rustfmt'],
\   'json': ['fixjson', 'jsonlint'],
\   'vim': ['vint']
\}

let g:ale_sign_error = '💩'
let g:ale_sign_warning = '⚡️'

let g:ale_fixers = {'javascript': ['prettier']}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma none --parser flow --semi false --print-width 100'
let g:ale_statusline_format = ['{%d} error(s)', '{%d} warning(s)', '']
let g:ale_lint_on_text_changed = 'never' " Slows down things if it's always linting
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
" let g:ale_open_list = 1

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'


