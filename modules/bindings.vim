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
nnoremap mm q
" Easy splits
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
nnoremap <silent> tt :tab split<CR>
" nerdtree
nnoremap <silent><F3> :NERDTreeToggle<CR>
nnoremap <silent><Leader>t :NERDTreeFind<CR>

" Unhighlight after search
nnoremap <silent> <Esc> :noh<CR><Esc>
" Searching
nnoremap <silent> <Leader>sp :Grepper<CR>
nnoremap <silent> <Leader>fr :Far<CR>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
" ALE jump to errors
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>
"" for denite
map <silent><C-P> :DeniteProjectDir -buffer-name=git -direction=dynamicbottom file_rec/git<CR>
if exists('g:oni_gui')
map <silent><Leader><Leader> :DeniteProjectDir -buffer-name=git -direction=dynamicbottom file_rec/git<CR>
endif
" denite file search (c-p uses gitignore, c-o looks at everything)
map <silent><C-O> :DeniteProjectDir -buffer-name=files -direction=dynamicbottom file_rec<CR>
map <silent><Leader>, :Denite buffer  -direction=dynamicbottom<CR>
map <silent><Leader>, :Denite file_mru  -direction=dynamicbottom<CR>
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#option('default', 'prompt', '>')
" -u flag to unrestrict (see ag docs)
call denite#custom#var('file_rec', 'command',
\ ['ag', '--follow', '--nocolor', '--nogroup','--ignore-case', '-u', '-g', ''])

call denite#custom#alias('source', 'file_rec/git', 'file_rec')

call denite#custom#var('file_rec/git', 'command',
\ ['ag', '--follow', '--nocolor', '--nogroup', '--ignore-case', '-g', ''])

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
" Misc
set wildchar=<Tab>
function! OpenTerminalDrawer() abort
  execute ':copen'
  execute ':term'
endfunction

nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>
