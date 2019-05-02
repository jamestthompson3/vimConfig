let b:ale_linters = ['eslint']
let b:ale_fixers = ['prettier']

nnoremap <silent> gh :call CocAction('doHover')<CR>
nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>
nnoremap <silent> K <plug>(coc-references)
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

if !exists('g:loaded_ts_config')
  packadd ultisnips
  packadd coc.nvim
  packadd vim-jsx-typescript
  packadd typescript-vim
  let g:loaded_ts_config = 1
endif

let g:mucomplete#chains.typescript = ['omni','c-p', 'c-n','file','path', 'ulti']
let g:mucomplete#chains['typescript.jsx'] = ['omni','c-p', 'c-n','file','path', 'ulti']
let g:mucomplete#chains['typescript.tsx'] = ['omni','c-p', 'c-n','file','path', 'ulti']
let g:ale_completion_enabled = 0

setlocal suffixesadd+=.js,.jsx,.ts,.tsx " navigate to imported files by adding the js(x) suffix
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\) " allows to jump to files declared with import { someThing } from 'someFile'
setlocal define=class\\s
setlocal foldmethod=syntax
setlocal foldlevelstart=99
setlocal foldlevel=99
setlocal commentstring=//%s
augroup Typescript
  autocmd BufWritePost * :syntax sync fromstart
augroup END
