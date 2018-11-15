scriptencoding = utf-8
let g:ale_linters = {
  \  'json': ['fixjson', 'jsonlint'],
  \   'vim': ['vint'],
  \}
" let g:ale_sign_error = '❌ '
let g:ale_sign_error = '!!'
" let g:ale_sign_warning = '⚠️'
let g:ale_sign_warning = '>>'
let g:ale_close_preview_on_insert = 1
let g:ale_fixers = {
      \  'html':['prettier'],
      \ 'markdown': ['prettier'],
      \ 'javascript': ['prettier']
      \ }
let g:ale_fix_on_save = 1
let g:ale_set_balloons = 1
let g:ale_list_window_size = 5
let g:ale_virtualtext_cursor = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_echo_msg_error_str = 'E'. ' '
let g:ale_echo_msg_warning_str = 'W'. ' '
let g:ale_echo_msg_info_str = nr2char(0xf05a) . ' '
let g:ale_echo_msg_format = '%severity%  %linter% - %s'
let g:ale_virtualtext_prompt = ''
let g:ale_sign_column_always = 1
let g:ale_statusline_format = [
      \ g:ale_echo_msg_error_str . ' %d',
      \ g:ale_echo_msg_warning_str . ' %d',
      \ nr2char(0xf4a1) . '  ']
