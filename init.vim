scriptencoding utf-8
set fileencoding=utf8

" Disable some default vim plugins:
let loaded_matchit = 1

" Load Custom Modules:
lua << EOF
require('mappings')
require('init')
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

let g:completion_chain_complete_list = [
      \{'complete_items': ['ts', 'lsp', 'snippet']},
      \{'mode': 'tags'},
      \{'mode': '<c-p>'},
      \{'mode': '<c-n>'},
      \{'mode': 'keyn'},
      \{'mode': 'keyp'},
      \{'mode': 'incl'},
      \{'mode': 'defs'},
      \{'mode': 'file'}
      \]
