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

" Configure the completion chains
let g:completion_chain_complete_list = {
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
      \	{'complete_items': ['path']},
      \{'mode': 'incl'},
      \{'mode': 'defs'}
      \	],
      \'typescriptreact' : [
      \	{'complete_items': ['ts']},
      \{'mode': '<c-p>'},
      \{'mode': '<c-n>'},
      \{'mode': 'keyn'},
      \{'mode': 'keyp'},
      \	{'complete_items': ['path']},
      \{'mode': 'incl'},
      \{'mode': 'defs'}
      \	],
      \'lua' : [
      \	{'complete_items': ['ts', 'lsp']}
      \	],
      \	'default' : [
      \{'complete_items': ['lsp', 'snippet', 'path']},
      \{'mode': '<c-p>'},
      \{'mode': '<c-n>'},
      \{'mode': 'keyn'},
      \{'mode': 'keyp'},
      \{'mode': 'file'}
      \	]
      \	}

colorscheme tokyo-metro
