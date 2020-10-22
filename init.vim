scriptencoding utf-8
set fileencoding=utf8

" Disable some default vim plugins:
let loaded_matchit = 1
let mapleader = "\<Space>"

" Load Custom Modules:
lua << EOF
require('mappings')
require('init')
-- require('ui') TODO figure out colors that work w/ treesitter
EOF

" TODO move to lua
let g:pear_tree_pairs = {
      \   '(': {'closer': ')'},
      \   '[': {'closer': ']'},
      \   '{': {'closer': '}'},
      \   "'": {'closer': "'"},
      \   '"': {'closer': '"'},
      \   '`': {'closer': '`'},
      \   '/\*': {'closer': '\*/'}
      \ }

colorscheme ghost_mono
