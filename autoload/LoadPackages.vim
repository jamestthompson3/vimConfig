function LoadPackages#Load()
if has('win16') || has('win32') || has('win64')
  let s:file_separator = '\\'
  let s:state_path = join(['','.cache','dein'], s:file_separator)
  let s:lang_server_build = 'powershell -executionpolicy bypass -F install.ps1'
else
 let s:file_separator = '/'
 let s:state_path = join(['','vim','bundles'], s:file_separator)
 let s:lang_server_build = 'bash install.sh'
endif

" Add the dein installation directory into runtimepath
let s:full_path = join(['','.cache', 'vimfiles', 'repos', 'github.com', 'Shougo', 'dein.vim'], s:file_separator)
exec 'set runtimepath+='.fnameescape($HOME.s:full_path)
call dein#begin($HOME.s:state_path)

call dein#add( 'Quramy/vim-js-pretty-template', { 'on_ft': 'javascript' } )
call dein#add( 'mattn/emmet-vim', {'on_ft': ['html', 'css']} )
call dein#add('wakatime/vim-wakatime', {} )
call dein#add('nightsense/stellarized', {} )
call dein#add('jordwalke/flatlandia', {} )
call dein#add('mattn/webapi-vim', {'on_path': '*'} )
call dein#add('mhartington/oceanic-next', {} )
call dein#add('kristijanhusak/vim-hybrid-material',{} )
call dein#add('styled-components/vim-styled-components', { 'on_ft': 'javascript' } )
call dein#add('neoclide/vim-jsx-improve', { 'on_ft': 'javascript' } )
call dein#add('rust-lang/rust.vim', { 'on_ft': 'rust'} )
call dein#add('heavenshell/vim-jsdoc', { 'on_cmd': 'JsDoc' } )
call dein#add('Raimondi/delimitMate', { 'lazy': 0, 'on_path': '*'} )
" call dein#add('w0rp/ale',{} )
call dein#add('Yggdroot/LeaderF', {'loadconf' : 1, 'merged' : 0, } )
call dein#add('Shougo/vimfiler.vim',{'merged' : 0, 'lazy': 0, 'on_path': '*' } )
call dein#add( 'andymass/vim-matchup',{} )
call dein#add('tpope/vim-projectionist',{ 'on_cmd' : ['A', 'AS', 'AV', 'AT', 'AD', 'Cd', 'Lcd', 'ProjectDo']} )
call dein#add('tpope/vim-commentary',{} )
call dein#add('jceb/vim-orgmode', {'on_ft': ['org', 'txt']} )
call dein#add('mhinz/vim-grepper' , { 'on_cmd' : 'Grepper', 'loadconf' : 1} )
call dein#add( 'brooth/far.vim' , { 'on_cmd' : 'Far'} )
call dein#add('wsdjeg/FlyGrep.vim', {'on_cmd' : 'FlyGrep'} )
call dein#add('vim-airline/vim-airline', {} )
call dein#add('vim-airline/vim-airline-themes', {} )
call dein#add('tpope/vim-fugitive', {'on_path': '*'} )
call dein#add('tpope/vim-surround', {'lazy': 0, 'on_path': '*'} )
call dein#add('equalsraf/neovim-gui-shim' , {} )
call dein#add('Shougo/unite.vim', {} )
call dein#add('tpope/vim-speeddating', {'on_ft': ['text', 'org']} )
call dein#add('ludovicchabant/vim-gutentags', {} )
call dein#add('skywind3000/gutentags_plus', {} )
call dein#add('prabirshrestha/asyncomplete.vim', { 'lazy':0, 'on_path': '*'} )
call dein#add('prabirshrestha/asyncomplete-flow.vim', { 'on_ft': 'javascript' } )
call dein#add('keremc/asyncomplete-racer.vim', { 'on_ft': 'rust' } )
call dein#add('prabirshrestha/async.vim', {} )
call dein#add('prabirshrestha/asyncomplete-buffer.vim', { 'lazy': 0, 'on_path': '*'} )
call dein#add('prabirshrestha/asyncomplete-tags.vim', {'lazy': 0, 'on_path': '*'} )
if has('nvim')
  call dein#add('autozimu/LanguageClient-neovim', {'rev': 'next', 'build': s:lang_server_build} )
endif
call dein#add('elzr/vim-json', { 'on_ft' : ['javascript','json']} )
call dein#add('ryanoasis/vim-devicons', {} )

call dein#end()
call dein#save_state()

endfunction
