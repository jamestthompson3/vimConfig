let b:ale_fixers = ['rustfmt']

let g:mucomplete#chains.rust = ['omni','keyn', 'keyp', 'c-p', 'c-n', 'tags', 'file','path', 'ulti']

" setl omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <silent> gd :call lsp#text_document_definition()<CR>
nnoremap <silent> gh  :call lsp#text_document_hover()<CR>

nnoremap <silent> <leader>R :RustRun<CR>
if has('Mac')
  let g:rust_clip_command = 'pbcopy'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

compiler cargo

