setlocal commentstring=//%s
let b:pear_tree_pairs = extend(deepcopy(g:pear_tree_pairs), {
      \ '`': {'closer': '`'}}, 'keep')
