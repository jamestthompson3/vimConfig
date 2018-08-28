let g:mapleader = "\<Space>"
inoremap jj <Esc>
" Copying and pasting from system clipboard
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
" Move windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Buffer switching
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
" Macros
nnoremap m q
" Easy splits
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
nnoremap <silent> tt :tab split<CR>

" Unhighlight after search
nnoremap <silent> <Esc> :noh<CR><Esc>
" Searching
nnoremap <silent> <Leader>sp :Grepper<CR>
nnoremap <silent> <Leader>fr :Far<CR>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
set wildchar=<Tab>
" ALE jump to errors
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>
"" for leader f
let g:Lf_ShortcutF = '<C-P>'
if exists('g:oni_gui')
let g:Lf_ShortcutF = '<Leader><Leader>'
endif
nnoremap <Leader>, :LeaderfBuffer<CR>
nnoremap <Leader>. :LeaderfMruCwd<CR>
" Quit window, quit and quit all other windows but current one
nnoremap <silent> wq ZZ
nnoremap <silent> q :bp\|bd #<CR>
nnoremap <silent> sq :only<CR>
nnoremap <silent> gl :pc<CR>
" completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" spell check
nnoremap <silent><F7> :setlocal spell! spell?<CR>

