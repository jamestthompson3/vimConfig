
function LoadPackages#Load()
if has('win16') || has('win32') || has('win64')
 let s:file_separator = '\\'
else
 let s:file_separator = '/'
endif

" Add the dein installation directory into runtimepath
let s:full_path = join(['','.cache', 'vimfiles', 'repos', 'github.com', 'Shougo', 'dein.vim'], s:file_separator)
let s:state_path = join(['','.cache','dein'], s:file_separator)
exec 'set runtimepath+='.fnameescape($HOME.s:full_path)
 call dein#begin($HOME.s:state_path)
 call dein#load_dict({
  \ 'Quramy/vim-js-pretty-template': { 'on_ft': 'javascript' },
  \ 'mattn/emmet-vim': {},
  \ 'wakatime/vim-wakatime': {},
  \ 'pangloss/vim-javascript': { 'on_ft': 'javascript'},
  \ 'kristijanhusak/vim-hybrid-material':{},
  \ 'styled-components/vim-styled-components': { 'on_ft': 'javascript' },
  \ 'maxmellon/vim-jsx-pretty': { 'on_ft': 'javascript' },
  \ 'neoclide/vim-jsx-improve': { 'on_ft': 'javascript' },
  \ 'othree/es.next.syntax.vim': { 'on_ft': 'javascript' },
  \ 'othree/javascript-libraries-syntax.vim': {
  \ 'on_ft': ['javascript', 'coffee', 'ls', 'typescript'] },
  \ 'othree/yajs.vim': { 'on_ft': 'javascript' },
  \ 'heavenshell/vim-jsdoc': { 'on_cmd': 'JsDoc' },
  \ 'Raimondi/delimitMate': { 'lazy': 0, 'on_path': '.*'},
  \ 'w0rp/ale':{},
  \ 'ctrlpvim/ctrlp.vim': {},
  \ 'Shougo/vimfiler.vim':{'merged' : 0, 'lazy': 0, 'on_path': '.*' },
  \  'andymass/vim-matchup':{},
  \ 'tpope/vim-projectionist':{ 'on_cmd' : ['A', 'AS', 'AV',
        \ 'AT', 'AD', 'Cd', 'Lcd', 'ProjectDo']},
  \ 'tpope/vim-commentary':{},
  \ 'jceb/vim-orgmode':{'on_ft': 'org'},
  \ 'mhinz/vim-grepper' : { 'on_cmd' : 'Grepper', 'loadconf' : 1},
  \ 'vim-airline/vim-airline': {},
  \ 'vim-airline/vim-airline-themes': {},
  \ 'tpope/vim-fugitive': {'on_path': '.*'},
  \ 'tpope/vim-surround': {'lazy': 0, 'on_path': '.*'},
  \ 'Shougo/unite.vim': {},
  \ 'tpope/vim-speeddating': {'on_ft': ['text', 'org']},
  \ 'ludovicchabant/vim-gutentags': {},
  \ 'ryanoasis/vim-devicons': {},
  \ 'prabirshrestha/asyncomplete.vim': { 'lazy':0, 'on_path': '.*'},
  \ 'prabirshrestha/asyncomplete-flow.vim': { 'on_ft': 'javascript' },
  \ 'prabirshrestha/async.vim': {},
  \ 'prabirshrestha/asyncomplete-buffer.vim': { 'lazy': 0, 'on_path': '.*'},
  \ 'runoshun/tscompletejob': { 'on_ft': ['typescript', 'javscript' ] },
  \ 'prabirshrestha/asyncomplete-tscompletejob.vim': { 'on_ft': [ 'typescript', 'javascript' ] },
  \ 'prabirshrestha/asyncomplete-tags.vim': {'lazy': 0, 'on_path': '.*'},
  \ 'elzr/vim-json': { 'on_ft' : ['javascript','json']}
\ })
 call dein#end()
 call dein#save_state()

endfunction
