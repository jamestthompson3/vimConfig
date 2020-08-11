scriptencoding utf-8
set fileencoding=utf8

" Disable some default vim plugins:
let loaded_matchit = 1
let mapleader = "\<Space>"

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

" Configure the completion chains
let g:completion_chain_complete_list = {
      \'default' : {
      \	'default' : [
      \{'complete_items': ['lsp', 'snippet']},
      \{'mode': '<c-p>'},
      \{'mode': '<c-n>'},
      \{'mode': 'keyn'},
      \{'mode': 'keyp'},
      \{'mode': 'file'}
      \	],
      \	'comment' : [],
      \	'string' : []
      \	},
      \'c' : [
      \	{'complete_items': ['ts']},
      \{'mode': 'tags'},
      \{'mode': '<c-p>'},
      \{'mode': '<c-n>'},
      \{'mode': 'keyn'},
      \{'mode': 'keyp'},
      \{'mode': 'incl'},
      \{'mode': 'defs'},
      \{'mode': 'file'}
      \	],
      \'python' : [
      \	{'complete_items': ['ts']},
      \{'mode': '<c-p>'},
      \{'mode': '<c-n>'},
      \{'mode': 'keyn'},
      \{'mode': 'keyp'},
      \{'mode': 'incl'},
      \{'mode': 'defs'},
      \{'mode': 'file'}
      \	],
      \'typescript' : [
      \	{'complete_items': ['ts']},
      \{'mode': '<c-p>'},
      \{'mode': '<c-n>'},
      \{'mode': 'keyn'},
      \{'mode': 'keyp'},
      \{'mode': 'incl'},
      \{'mode': 'defs'},
      \{'mode': 'file'}
      \	],
      \'typescriptreact' : [
      \	{'complete_items': ['ts']},
      \{'mode': '<c-p>'},
      \{'mode': '<c-n>'},
      \{'mode': 'keyn'},
      \{'mode': 'keyp'},
      \{'mode': 'incl'},
      \{'mode': 'defs'},
      \{'mode': 'file'}
      \	],
      \'lua' : [
      \	{'complete_items': ['ts']}
      \	],
      \}
