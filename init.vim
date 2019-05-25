set encoding=utf8
scriptencoding utf-8
set fileencoding=utf8
set fileformat=unix

" Disable some default vim plugins:
let g:did_install_default_menus = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_zipPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_gzip = 1

" User Globals:
let g:isWindows = has('win16') || has('win32') || has('win64')
let g:isMac = system('uname') =~ 'Darwin\n'

if g:isWindows
  let g:file_separator = '\\'
  let g:python3_host_prog = 'C:\Users\taylor.thompson\AppData\Local\Programs\Python\Python36-32\python.exe'
else
  let g:file_separator = '/'
  let g:python3_host_prog= '/usr/local/bin/python3'
endif

let g:modules_folder = 'modules' . g:file_separator
let g:sessionPath = '~'.g:file_separator.'sessions'.g:file_separator
let g:loaded_python_provider = 1
let g:cscope_options_default    = '-C'
let g:cscope_rebuild_on_refresh = 0
let &cscopeprg = 'cscope'

" plugin globals:
let g:netrw_localrmdir = 'rm -r' " use this command to remove folder
let g:netrw_banner=0
let g:netrw_winsize=45
let g:netrw_liststyle=3
let g:gutentags_cache_dir = '~/.cache/'
let g:gutentags_project_root = ['package.json', '.git']
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#no_mappings = 1
let g:mucomplete#buffer_relative_paths = 1
let g:mucomplete#chains = {}
let g:mucomplete#chains.default = ['incl','omni','tags', 'c-p', 'defs', 'c-n', 'keyn', 'keyp', 'file', 'path', 'ulti']
let g:mucomplete#minimum_prefix_length = 2
let g:ultisnipssnippetsdir = $myvimrc . g:file_separator . 'ultisnips'
let g:UltiSnipsExpandTrigger = '<c-l>'
let g:matchup_matchparen_deferred = 1
let g:matchup_match_paren_timeout = 100
let g:matchup_matchparen_stopline = 200
let g:vimwiki_nested_syntaxes = {'py': 'python','js': 'javascript', 'rs': 'rust', 'ts': 'typescript'}
let g:hexokinase_virtualtext = '██'
let g:hexokinase_ftautoload = ['css', 'xml', 'javascript']
let g:pear_tree_pairs = {
      \   '(': {'closer': ')'},
      \   '[': {'closer': ']'},
      \   '{': {'closer': '}'},
      \   "'": {'closer': "'"},
      \   '"': {'closer': '"'},
      \   '`': {'closer': '`'},
      \   '/*': {'closer': '*/'}
      \ }
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_timeout = 60
let g:pear_tree_repeatable_expand = 1
let g:vista_sidebar_width = 50

" ALE:
let g:ale_completion_enabled = 1
let g:ale_linters_explicit = 1
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '>>'
let g:ale_close_preview_on_insert = 1
let g:ale_fix_on_save = 1
let g:ale_list_window_size = 5
let g:ale_virtualtext_cursor = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_echo_msg_info_str = nr2char(0xf05a) . ' '
let g:ale_echo_msg_format = '[%linter%] %s'
let g:ale_virtualtext_prompt = ' '
let g:ale_sign_column_always = 0

" Load Custom Modules:
execute 'runtime! '.g:modules_folder.'*'

" Commands:
command! -bang -nargs=* Snake call tools#Snake(<q-args>)
command! -bang -nargs=* Camel call tools#Camel(<q-args>)
command! Scratch call tools#makeScratch()
command! -nargs=1 -complete=buffer Bs :call tools#BufSel("<args>")
command! GManage call git#manage()
command! Diff call git#diff()
command! TDiff call git#threeWayDiff()
command! -range Gblame echo join(systemlist("git blame -L <line1>,<line2> " . expand('%')), "\n")
command! -nargs=1 -complete=command Redir silent call tools#redir(<q-args>)

function! s:checkDocs(args) abort
  let l:stub = tools#getStub()
  call system(len(split(a:args, ' ')) == 0 ?
        \ l:stub . (expand('<bang>') == "!" || &filetype . '%20') . expand('<cword>') . "'" : len(split(a:args, ' ')) == 1 ?
        \ l:stub . (expand('<bang>') == "!" || &filetype . '%20') . a:args . "'" : l:stub . substitute(a:args, '\s\+', '%20', 'g') . "'")
endfunction

command! -bang -nargs=* DD silent! call s:checkDocs(<q-args>)
command! -bang -nargs=+ ReplaceQF call tools#Replace_qf(<f-args>)
command! -bang SearchBuffers call tools#GrepBufs()
command! -nargs=+ -complete=dir -bar SearchProject execute 'silent! grep!'.<q-args>
command! CSRefresh :call symbols#CSRefreshAllConns()
" TODO fix this
"cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))

command! -nargs=+ -complete=file FindFileByType call tools#GetFilesByType(<q-args>)

command! PackagerInstall call tools#PackagerInit() | call packager#install()
command! -bang PackagerUpdate call tools#PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
command! PackagerClean call tools#PackagerInit() | call packager#clean()
command! PackagerStatus call tools#PackagerInit() | call packager#status()

command! Blue  :Monotone 193 90 90
command! Red   :Monotone 360 96 80
command! Reset :Monotone 217, 0, 70

" modify selected text using combining diacritics
command! -range -nargs=0 Overline        call tools#CombineSelection(<line1>, <line2>, '0305')
command! -range -nargs=0 Underline       call tools#CombineSelection(<line1>, <line2>, '0332')
command! -range -nargs=0 DoubleUnderline call tools#CombineSelection(<line1>, <line2>, '0333')
command! -range -nargs=0 Strikethrough   call tools#CombineSelection(<line1>, <line2>, '0336')

" Jira stuff
command! JIRAIssues call jira#getIssues()
command! -range -nargs=0 JIRATransition call jira#transitionIssue()

