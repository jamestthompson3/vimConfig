scriptencoding utf-8
set fileencoding=utf8
set fileformat=unix

" Disable some default vim plugins:
let g:did_install_default_menus = 1
let g:loaded_tutor_mode_plugin = 1
let loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_zipPlugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_gzip = 1
let g:loaded_python_provider = 1

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


" Load Custom Modules:
execute 'runtime! '.g:modules_folder.'*'

" Commands:
command! Scratch call tools#makeScratch()
command! -nargs=1 -complete=buffer Bs :call tools#BufSel("<args>")
command! GManage call git#manage()
command! Diff call git#diff()
command! TDiff call git#threeWayDiff()
command! -range Gblame echo join(systemlist("git blame -L <line1>,<line2> " . expand('%')), "\n")
command! -nargs=1 -complete=command Redir silent call tools#redir(<q-args>)

command! -bang -nargs=+ ReplaceQF call tools#Replace_qf(<f-args>)
command! -bang SearchBuffers call tools#GrepBufs()
command! -nargs=+ -complete=dir -bar SearchProject execute 'silent! grep!'.<q-args>.' | cwindow'
command! CSRefresh call symbols#CSRefreshAllConns()
command! CSBuild call symbols#buildCscopeFiles()
" TODO fix this
"cgetexpr system(&grepprg . ' ' . shellescape(<q-args>))

command! -nargs=+ -complete=file FindFileByType call tools#GetFilesByType(<q-args>)

command! PackagerInstall call tools#PackagerInit() | call packager#install()
command! -bang PackagerUpdate call tools#PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
command! PackagerClean call tools#PackagerInit() | call packager#clean()
command! PackagerStatus call tools#PackagerInit() | call packager#status()
command! ShowConsts match ConstStrings '\<\([A-Z]\{2,}_\?\)\+\>'

command! Blue  :Monotone 193 90 90
command! Red   :Monotone 360 96 80
command! Reset :Monotone 217, 0, 70
