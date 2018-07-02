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
 call dein#load_dict({
  \ 'Quramy/vim-js-pretty-template': { 'on_ft': 'javascript' },
  \ 'mattn/emmet-vim': {},
  \ 'wakatime/vim-wakatime': {},
  \ 'nightsense/stellarized': {},
  \  'jordwalke/flatlandia': {},
  \ 'mhartington/oceanic-next': {},
  \ 'kristijanhusak/vim-hybrid-material':{},
  \ 'styled-components/vim-styled-components': { 'on_ft': 'javascript' },
  \ 'neoclide/vim-jsx-improve': { 'on_ft': 'javascript' },
  \ 'heavenshell/vim-jsdoc': { 'on_cmd': 'JsDoc' },
  \ 'Raimondi/delimitMate': { 'lazy': 0, 'on_path': '*'},
  \ 'w0rp/ale':{},
  \ 'Yggdroot/LeaderF': {'loadconf' : 1, 'merged' : 0, },
  \ 'Shougo/vimfiler.vim':{'merged' : 0, 'lazy': 0, 'on_path': '*' },
  \  'andymass/vim-matchup':{},
  \ 'tpope/vim-projectionist':{ 'on_cmd' : ['A', 'AS', 'AV',
        \ 'AT', 'AD', 'Cd', 'Lcd', 'ProjectDo']},
  \ 'tpope/vim-commentary':{},
  \ 'jceb/vim-orgmode': {'on_ft': ['org', 'txt']},
  \ 'mhinz/vim-grepper' : { 'on_cmd' : 'Grepper', 'loadconf' : 1},
  \ 'wsdjeg/FlyGrep.vim': {'on_cmd' : 'FlyGrep'},
  \ 'vim-airline/vim-airline': {},
  \ 'vim-airline/vim-airline-themes': {},
  \ 'tpope/vim-fugitive': {'on_path': '*'},
  \ 'tpope/vim-surround': {'lazy': 0, 'on_path': '*'},
  \ 'Shougo/unite.vim': {},
  \ 'tpope/vim-speeddating': {'on_ft': ['text', 'org']},
  \ 'ludovicchabant/vim-gutentags': {},
  \ 'skywind3000/gutentags_plus': {},
  \ 'prabirshrestha/asyncomplete.vim': { 'lazy':0, 'on_path': '*'},
  \ 'prabirshrestha/asyncomplete-flow.vim': { 'on_ft': 'javascript' },
  \ 'prabirshrestha/asyncomplete-lsp.vim': {},
  \ 'prabirshrestha/async.vim': {},
  \ 'prabirshrestha/asyncomplete-buffer.vim': { 'lazy': 0, 'on_path': '*'},
  \ 'prabirshrestha/asyncomplete-tags.vim': {'lazy': 0, 'on_path': '*'},
  \ 'prabirshrestha/vim-lsp': {},
  \ 'elzr/vim-json': { 'on_ft' : ['javascript','json']},
  \ 'ryanoasis/vim-devicons': {},
\ })
 call dein#end()
 call dein#save_state()

endfunction
