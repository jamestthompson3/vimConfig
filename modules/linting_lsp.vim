scriptencoding = utf-8
let g:ale_linters = {
  \   'python': ['flake8', 'pylint'],
   \ 'javascript': ['eslint', 'flow-language-server' ],
  \   'json': ['fixjson', 'jsonlint'],
  \   'vim': ['vint'],
  \ 'rust': ['rls', 'cargo']
  \}

" if !has('win16') || !has('win32') || !has('win64')
" let g:ale_linters_ignore = { 'javascript': ['flow']}
" " LSP only working on Linux currently
" let g:LanguageClient_serverCommands = {
"     \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
"     \ 'javascript': ['flow', 'lsp']
"     \ }


" let g:LanguageClient_rootMarkers = {
"         \ 'javascript': ['.flowconfig'],
"         \ 'rust': ['Cargo.toml'],
"         \ }

" let g:LanguageClient_diagnosticsDisplay = {
"       \ 1: {
"       \  'name': 'Error',
"       \      'texthl': 'ALEError',
"       \      'signText': '>>',
"       \      'signTexthl': 'ALEErrorSign',
"       \  },
"       \  2: {
"       \      'name': 'Warning',
"       \      'texthl': 'ALEWarning',
"       \      'signText': '⚡️',
"       \      'signTexthl': 'ALEWarningSign',
"       \  },
"       \  3: {
"       \      'name': 'Information',
"       \      'texthl': 'ALEInfo',
"       \      'signText': 'ℹ',
"       \       'signTexthl': 'ALEInfoSign',
"        \  },
"       \  4: {
"      \    'name': 'Hint',
"       \   'texthl': 'ALEInfo',
"       \  'signText': '➤',
"       \    'signTexthl': 'ALEInfoSign',
"       \  }
"    \  }

" let g:LanguageClient_loggingFile = expand('~/lsp_log.log')
" let g:LanguageClient_loggingLevel = 'DEBUG'
" endif

if has ('nvim')
  let g:ale_sign_error = '🚨'
  " let g:ale_sign_error = '>>'
endif

let g:ale_sign_warning = '⚡️'
let g:ale_fixers = {'javascript': ['prettier'], 'rust': ['rustfmt'], 'html':['tidy']}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0
let g:ale_set_balloons = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma none --parser flow --semi false --print-width 100'
let g:ale_statusline_format = ['{%d} error(s)', '{%d} warning(s)', '']
let g:ale_lint_on_text_changed = 'normal' " Slows down things if it's always linting
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'


