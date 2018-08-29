scriptencoding = utf-8
let g:ale_linters = {
  \   'python': ['flake8', 'pylint'],
   \ 'javascript': ['eslint', 'flow'],
  \ 'rust': ['cargo'],
  \   'json': ['fixjson', 'jsonlint'],
  \ 'c': ['cquery', 'clang'],
  \   'vim': ['vint'],
  \}
let g:ale_sign_error = '❌ '
let g:ale_sign_warning = '⚠️'
let g:ale_fixers = {'javascript': ['prettier'], 'rust': ['rustfmt'], 'html':['tidy'], 'markdown': ['prettier'], 'c': ['clang-format']}
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


