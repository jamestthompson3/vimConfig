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
" Create function to manage thing in a semi-sane way
let g:isWindows = has('win16') || has('win32') || has('win64')

let g:isMac = system('uname') =~ 'Darwin\n'

if g:isWindows
 let g:file_separator = '\\'
else
 let g:file_separator = '/'
endif

let g:modules_folder = 'modules' . g:file_separator
let g:sessionPath = '~'.g:file_separator.'sessions'.g:file_separator

" plugin globals:
let g:netrw_localrmdir = 'rm -r' " use this command to remove folder
let g:netrw_banner=0
let g:netrw_winsize=15
let g:netrw_liststyle=3
let g:gutentags_cache_dir = '~/.cache/'
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#no_mappings = 1
let g:mucomplete#buffer_relative_paths = 1
let g:mucomplete#chains = {}
let g:mucomplete#chains.default = ['incl','omni','tags', 'c-p', 'defs', 'c-n', 'keyn', 'keyp', 'file', 'path', 'ulti']
let g:mucomplete#minimum_prefix_length = 2
let g:ultisnipssnippetsdir = $myvimrc . g:file_separator . 'ultisnips'
let g:ultisnipsexpandtrigger = '<c-l>'
let g:matchup_matchparen_deferred = 1
let g:matchup_match_paren_timeout = 100
let g:matchup_matchparen_stopline = 200
let g:gutentags_project_root = ['package.json']
let g:vimwiki_nested_syntaxes = {'py': 'python','js': 'javascript', 'rs': 'rust', 'ts': 'typescript'}
" let g:monotone_color = [51, 80, 60]
" let g:monotone_secondary_hue_offset = 300
let g:hexokinase_virtualtext = '██'
let g:hexokinase_ftautoload = ['css', 'xml', 'javascript']
let g:pear_tree_pairs = {
    \   '(': {'closer': ')'},
    \   '[': {'closer': ']'},
    \   '{': {'closer': '}'},
    \   "'": {'closer': "'"},
    \   '"': {'closer': '"'},
    \   '`': {'closer': '`'},
    \   '<*>': {'closer': '</*>', 'not_like': '/$'}
    \ }
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
let g:pear_tree_timeout = 60
let g:pear_tree_repeatable_expand = 1
let g:vista_sidebar_width = 70

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
function! LoadCustomModule( name )
  let l:script = g:modules_folder .  a:name . '.vim'
  execute ':runtime ' . l:script
endfunction

call LoadCustomModule( 'core' )
call LoadCustomModule( 'ui' )
call LoadCustomModule( 'bindings' )

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

command! -bang -nargs=+ ReplaceQF call tools#Replace_qf(<f-args>)
command! Tagbar call symbols#loadTagbar()
command! -bang SearchBuffers call tools#GrepBufs()
command! -nargs=+ -complete=dir -bar SearchProject execute 'silent! grep!'.<q-args>
command! -nargs=+ -complete=file FindFileByType call tools#GetFilesByType(<q-args>)

command! PackagerInstall call tools#PackagerInit() | call packager#install()
command! -bang PackagerUpdate call tools#PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
command! PackagerClean call tools#PackagerInit() | call packager#clean()
command! PackagerStatus call tools#PackagerInit() | call packager#status()

command! Blue  :Monotone 193 90 90
command! Red   :Monotone 360 96 80
command! Reset :Monotone 217, 0, 70

