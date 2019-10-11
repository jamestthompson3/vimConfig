let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
      \ '`': {'closer': '`'},
      \ '/\*\*': {'closer': '\*/'},
      \ '<*>': {'closer': '</*>',
      \         'not_if': ['br', 'hr', 'img', 'input', 'link', 'meta',
      \                    'area', 'base', 'col', 'command', 'embed',
      \                    'keygen', 'param', 'source', 'track', 'wbr'],
      \         'not_like': '/$'
      \        }
      \ }, 'keep')
