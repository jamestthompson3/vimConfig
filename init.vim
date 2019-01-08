set encoding=utf8
scriptencoding utf-8
set fileencoding=utf8
set fileformat=unix

" Disable some defualt vim plugins: {{{
let g:did_install_default_menus = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_gzip = 1
let g:loaded_netrwPlugin = 1
" }}}

" User globals: {{{
let g:isOni = exists('g:gui_oni')
" Create function to manage thing in a semi-sane way
let g:isWindows = has('win16') || has('win32') || has('win64')

if g:isWindows
 let g:file_separator = '\\'
else
 let g:file_separator = '/'
endif

let g:modules_folder = 'modules' . g:file_separator

" }}}

" Load plugins
call LoadPackages#Load()

" Plugin globals: {{{
let g:netrw_localrmdir = 'rm -r' " use this command to remove folder
let g:netrw_winsize = 20 " smaller explorer window
let g:gutentags_cache_dir = '~/.cache/'
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#no_mappings = 1
let g:mucomplete#buffer_relative_paths = 1
let g:mucomplete#chains = {
      \ 'default': ['omni', 'incl', 'c-p', 'defs', 'tags', 'c-n', 'keyn', 'keyp', 'file', 'path', 'ulti'],
      \ 'vim': ['cmd', 'omni', 'defs', 'c-p', 'c-n', 'file', 'incl', 'keyn', 'keyp', 'tags', 'path', 'ulti'],
      \ }
let g:mucomplete#minimum_prefix_length = 2
let g:UltiSnipsSnippetsDir = $MYVIMRC . g:file_separator . 'UltiSnips'
let g:UltiSnipsExpandTrigger = '<c-l>'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:fzf_layout = { 'window': 'enew' }
let g:matchup_matchparen_deferred = 1
let g:matchup_match_paren_timeout = 100
let g:goyo_width = 120
let g:colorizer_auto_filetype='css,html,javascript.jsx'
let g:buftabline_show = 1
let g:buftabline_indicators = 1
let g:buftabline_separators = 1
let g:buftabline_numbers = 2
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:webdevicons_enable = 1
" }}}

" ALE: {{{
let g:ale_linters = {
  \  'json': ['fixjson', 'jsonlint'],
  \   'vim': ['vint'],
  \}

let g:ale_sign_error = '!!'
let g:ale_sign_warning = '>>'
let g:ale_close_preview_on_insert = 1
let g:ale_fixers = {
      \  'html':['prettier'],
      \ 'markdown': ['prettier'],
      \ 'javascript': ['prettier']
      \ }
let g:ale_fix_on_save = 1
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
" }}}

" Load custom modules: {{{
function! LoadCustomModule( name )
  let l:script = g:modules_folder .  a:name . '.vim'
  exec ':runtime ' . l:script
endfunction
" }}}

call LoadCustomModule( 'core' )
call LoadCustomModule( 'ui' )
call LoadCustomModule( 'bindings' )

" Commands: {{{
" Use dirvish over netrw, but still preserve netrw behavior
command! -nargs=? -complete=dir Explore Dirvish <args> | silent call feedkeys('20<c-w>|')
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args> | silent call feedkeys('20<c-w>|')
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args> | silent call feedkeys('20<c-w>|')

command! -bang -nargs=* Snake call tools#Snake(<q-args>)
command! -bang -nargs=* Camel call tools#Camel(<q-args>)
" fuzzy search through git branch, checkout selected branch
command! -bang -nargs=0 GCheckout
     \ call fzf#run({
     \ 'source': 'git branch',
     \ 'sink':   function('s:open_branch_fzf'),
     \ 'down': '40%'
     \ }, <bang>0)

command! -bang -nargs=+ ReplaceQF call tools#Replace_qf(<q-args>)
command! -bang SearchBuffers call tools#GrepBufs()
command! -bang FindandReplace call tools#FindReplace()
command! -nargs=+ -complete=file_in_path -bar SearchProject silent! grep! <args> | redraw!
" }}}
