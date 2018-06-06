let mapleader = "\<Space>"
inoremap jj <Esc>
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
nnoremap <silent> <Tab> :wincmd p<CR>
xnoremap <Leader>p "+p
xnoremap <Leader>P "+P
nnoremap <Leader>cls <Plug>CommentaryLine
" for leader f
let g:Lf_ShortcutF = '<Leader>,'
nnoremap <silent> q :bd<CR>
" completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
