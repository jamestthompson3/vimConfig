" TODO make search and replace populate qf list
" function! SearchandReplace() abort
"   let term = input('Enter search term: ')
"   exec ":GrepperRg " . term
" endfunction

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
" Comments
noremap <silent> <Leader>c  :Commentary<CR>
" Easy splits
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
nnoremap <silent> tt :tab split<CR>

" Unhighlight after search
nnoremap <silent> <Esc> :noh<CR><Esc>
nnoremap <silent> <Leader>sp :FlyGrep<CR>
" nnoremap <silent> <Leader>fr :call SearchandReplace()<CR>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
set wildchar=<Tab>
"" for leader f
let g:Lf_ShortcutF = '<Leader><Leader>'
nnoremap <Leader>, :LeaderfBuffer<CR>
" Quit window, quit and quit all other windows but current one
nnoremap <silent> wq ZZ
nnoremap <silent> q :bp\|bd #<CR>
nnoremap <silent> sq :only<CR>
" completion
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" spell check
nnoremap <silent><F7> :setlocal spell! spell?<CR>

