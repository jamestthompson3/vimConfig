function LoadPackages#Load()
if has('win16') || has('win32') || has('win64')
  let s:file_separator = '\\'
  let s:state_path = join(['','.cache','dein'], s:file_separator)
else
 let s:file_separator = '/'
 let s:state_path = join(['','vim','bundles'], s:file_separator)
endif

" Add the dein installation directory into runtimepath
let s:full_path = join(['','.cache', 'vimfiles', 'repos', 'github.com', 'Shougo', 'dein.vim'], s:file_separator)
exec 'set runtimepath+='.fnameescape($HOME.s:full_path)
call dein#begin($HOME.s:state_path)
" Javascript stuff
call dein#add('Quramy/vim-js-pretty-template', { 'on_ft': 'javascript' } )
call dein#add('mattn/emmet-vim', {'on_ft': ['html', 'css', 'js']} )
call dein#add('elzr/vim-json', { 'on_ft' : ['javascript','json']} )
call dein#add('elzr/vim-json', { 'on_ft' : ['javascript','json']} )
call dein#add('styled-components/vim-styled-components', { 'on_ft': 'javascript' } )
call dein#add('neoclide/vim-jsx-improve', { 'on_ft': 'javascript' } )
call dein#add('heavenshell/vim-jsdoc', { 'on_cmd': 'JsDoc' } )
" Themes
call dein#add('chrisbra/Colorizer', {} )
call dein#add('jordwalke/flatlandia', {} )
call dein#add('fenetikm/falcon', {} )
call dein#add('nightsense/snow', {} )
call dein#add('andreypopp/vim-colors-plain', {} )
call dein#add('kristijanhusak/vim-hybrid-material',{} )
call dein#add('mhartington/oceanic-next', {} )
call dein#add('mattn/webapi-vim', {'on_path': '*'} )
" Rust
call dein#add('rust-lang/rust.vim', { 'on_ft': 'rust'} )
" Reason
call dein#add('reasonml-editor/vim-reason-plus', { 'on_ft': 'reason'} )
" Utils
call dein#add('wakatime/vim-wakatime', {} )
call dein#add('unblevable/quick-scope', {} )
call dein#add('Raimondi/delimitMate', { 'lazy': 0, 'on_path': '*'} )
call dein#add('w0rp/ale',{} )
call dein#add('scrooloose/nerdtree',{} )
call dein#add('Shougo/denite.nvim')
call dein#add('Shougo/neomru.vim')
call dein#add('andymass/vim-matchup',{} )
call dein#add('jceb/vim-orgmode', {'on_ft': ['org', 'txt']} )
call dein#add('mhinz/vim-grepper' , { 'on_cmd' : 'Grepper', 'loadconf' : 1} )
call dein#add('brooth/far.vim' , { 'on_cmd' : 'Far'} )
call dein#add('wsdjeg/FlyGrep.vim', {'on_cmd' : 'FlyGrep'} )
call dein#add('vim-airline/vim-airline', {} )
call dein#add('vim-airline/vim-airline-themes', {} )
" Tyler Pope Magic
call dein#add('tpope/vim-commentary',{} )
call dein#add('tpope/vim-fugitive', {} )
call dein#add('tpope/vim-unimpaired', {} )
call dein#add('tpope/vim-surround', {'lazy': 0, 'on_path': '*'} )
call dein#add('tpope/vim-speeddating', {'on_ft': ['text', 'org']} )
" Tags
call dein#add('ludovicchabant/vim-gutentags', { 'on_ft': ['python', 'c', 'cpp', 'rust']} )
call dein#add('skywind3000/gutentags_plus', {} )
" Async complete stuff
call dein#add('Shougo/deoplete.nvim', {} )
call dein#add('carlitux/deoplete-ternjs', {} )
call dein#add('racer-rust/vim-racer', {} )
call dein#add('copy/deoplete-ocaml', {} )
" devicon
call dein#add('ryanoasis/vim-devicons', {} )

call dein#end()
call dein#save_state()

endfunction
