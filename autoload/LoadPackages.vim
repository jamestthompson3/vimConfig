scriptencoding utf-8
function LoadPackages#Load()
  if g:isWindows
    let s:file_separator = '\\'
    let s:state_path = join(['','.cache','dein'], s:file_separator)
  else
    let s:file_separator = '/'
    let s:state_path = join(['','vim','bundles'], s:file_separator)
  endif

  " Add the dein installation directory into runtimepath
  let s:full_path = join(['','.cache', 'dein.vim'], s:file_separator)
  exec 'set runtimepath+='.fnameescape($HOME.s:full_path)
  call dein#begin($HOME.s:state_path)
  "                ╔══════════════════════════════════════════╗
  "                ║               » JAVASCRIPT «             ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('elzr/vim-json', { 'on_ft' : ['javascript','json']} )
  call dein#add('heavenshell/vim-jsdoc', { 'on_cmd': 'JsDoc' } )
  call dein#add('mattn/emmet-vim', {'on_ft': ['html', 'css', 'javascript']} )
  call dein#add('~/code/vim-jest', { 'on_ft': ['javascript', 'typescript']})
  "                ╔══════════════════════════════════════════╗
  "                ║                » REASON «                ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('reasonml-editor/vim-reason-plus', { 'on_ft': 'reason'} )
  "                ╔══════════════════════════════════════════╗
  "                ║                 » NIM «                  ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('zah/nim.vim', { 'on_ft': 'nim'} )
  "                ╔══════════════════════════════════════════╗
  "                ║                 » RUST «                 ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('rust-lang/rust.vim', { 'on_ft': 'rust'} )

  "                ╔══════════════════════════════════════════╗
  "                ║               » THEMES «                 ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('~/code/tokyo-metro.vim')
  "                ╔══════════════════════════════════════════╗
  "                ║                  » UTILS «               ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('Shougo/neomru.vim')
  call dein#add('chrisbra/Colorizer', { 'on_ft':  ['css', 'html', 'javascript.jsx', 'vim']})
  call dein#add('SirVer/ultisnips')
  call dein#add('andymass/vim-matchup')
  call dein#add('majutsushi/tagbar', { 'on_cmd': 'Tagbar' })
  call dein#add('iamcco/markdown-preview.nvim', { 'build': 'cd app && yarn install', 'on_ft': ['org', 'markdown']} )
  call dein#add('jceb/vim-orgmode', {'on_ft': ['org', 'txt']} )
  call dein#add('junegunn/fzf', { 'build': './install --all'})
  call dein#add('junegunn/fzf.vim')
  call dein#add('junegunn/goyo.vim' , { 'on_cmd' : 'Goyo'} )
  call dein#add('justinmk/vim-dirvish')
  call dein#add('mattn/webapi-vim')
  call dein#add('romainl/vim-qf')
  call dein#add('sheerun/vim-polyglot')
  call dein#add('thinca/vim-localrc')
  call dein#add('unblevable/quick-scope')
  call dein#add('ap/vim-buftabline')
  call dein#add('w0rp/ale')
  call dein#add('zirrostig/vim-schlepp')
  "                ╔══════════════════════════════════════════╗
  "                ║             » TPOPE MAGIC «              ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('tpope/vim-commentary')
  call dein#add('tpope/vim-fugitive')
  call dein#add('tpope/vim-scriptease', { 'on_ft': 'vim' })
  call dein#add('tpope/vim-speeddating', {'on_ft': ['text', 'org']} )
  call dein#add('tpope/vim-surround')
  "                ╔══════════════════════════════════════════╗
  "                ║                 » TAGS «                 ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('ludovicchabant/vim-gutentags')
  "                ╔══════════════════════════════════════════╗
  "                ║              » COMPLETION «              ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('lifepillar/vim-mucomplete')
  call dein#add('racer-rust/vim-racer', { 'on_ft': 'rust' })
  "                ╔══════════════════════════════════════════╗
  "                ║                » ICONS «                 ║
  "                ╚══════════════════════════════════════════╝
  call dein#add('ryanoasis/vim-devicons')

  call dein#end()
  call dein#save_state()

endfunction
