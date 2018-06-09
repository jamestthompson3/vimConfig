let mapleader = "\<Space>"
inoremap jj <Esc>
" Copying and pasting from system clipboard
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
" Move windows
nnoremap <silent> <Tab> :wincmd p<CR>
nnoremap <silent> <S-Tab> <C-W><C-P>
noremap <Leader>c <Plug>CommentaryLine
" Easy splits
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
" Buffer and tab management
nnoremap <silent> <Leader>, :b<Tab>
nnoremap <silent> tt :tab split<CR>

" Unhighlight after search
nnoremap <silent> <Esc> :noh<CR><Esc>
nnoremap <silent> <Leader>sp :FlyGrep<CR>
set wildchar=<Tab>
" for leader f
let g:Lf_ShortcutF = '<Leader><Leader>'
" Quit window, quit and quit all other windows but current one
nnoremap <silent> q ZZ
nnoremap <silent> sq :only<CR>
" completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
