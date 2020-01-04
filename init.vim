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
