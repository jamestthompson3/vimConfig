let g:tagbar_type_typescript = {
      \ 'ctagstype' : 'typescript',
      \ 'kinds'     : [
      \ 'f:functions',
      \ 'c:classes',
      \ 'i:interfaces',
      \ 'g:enums',
      \ 'e:enumerators',
      \ 'm:methods',
      \ 'n:namespaces',
      \ 'p:properties',
      \ 'v:variables',
      \ 'C:constants',
      \ 'G:generators',
      \ 'a:aliases',
      \ ],
      \ 'sro'        : '.',
      \ 'kind2scope' : {
      \ 'c' : 'classes',
      \ 'a' : 'aliases',
      \ 'f' : 'functions',
      \ 'v' : 'variables',
      \ 'm' : 'methods',
      \ 'i' : 'interfaces',
      \ 'e' : 'enumerators',
      \ 'enums'      : 'g'
      \ },
      \ 'scope2kind' : {
      \ 'classes'    : 'c',
      \ 'aliases'    : 'a',
      \ 'functions'  : 'f',
      \ 'variables'  : 'v',
      \ 'methods'    : 'm',
      \ 'interfaces' : 'i',
      \ 'enumerators'      : 'e',
      \ 'enums'      : 'g'
      \ }
      \ }

let g:tagbar_type_typescriptreact = 1

" For andymass/vim-matchup plugin
if exists("loaded_matchup")
  setlocal matchpairs=(:),{:},[:],<:>
  let b:match_words = '<\@<=\([^/][^ \t>]*\)\g{hlend}[^>]*\%(/\@<!>\|$\):<\@<=/\1>'
  let b:match_skip = 's:comment\|string'
endif
