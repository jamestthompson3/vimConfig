let b:ale_linters = ['tsserver', 'eslint']
let b:ale_fixers = ['prettier']

nnoremap <silent> gh :ALEHover<CR>
nnoremap <silent> gd :ALEGoToDefinition<CR>
nnoremap <silent> K :ALEFindReferences<CR>

if !exists('g:loaded_ts_config')
  packadd ultisnips
  packadd Colorizer
  packadd vim-jsx-typescript
  packadd typescript-vim
  let g:loaded_ts_config = 1
endif

let g:mucomplete#chains.typescript = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']
let g:mucomplete#chains['typescript.tsx'] = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']



inoremap `<CR>       `<CR>`<esc>O<tab>
setlocal suffixesadd+=.js,.jsx,.ts,.tsx " navigate to imported files by adding the js(x) suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
setlocal foldmethod=syntax
setlocal foldlevelstart=99
setlocal foldlevel=99

augroup Typescript
  autocmd BufWritePost * :syntax sync fromstart
augroup END
