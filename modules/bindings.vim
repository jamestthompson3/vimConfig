scriptencoding = utf-8
"                ╔══════════════════════════════════════════╗
"                ║         » LEADER AND QUICK ESCAPE «      ║
"                ╚══════════════════════════════════════════╝
let g:mapleader = "\<Space>"
inoremap jj <Esc>
"                ╔══════════════════════════════════════════╗
"                ║             » SYSTEM CLIPBOARD «         ║
"                ╚══════════════════════════════════════════╝
xnoremap <Leader>y "+y
xnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
"                ╔══════════════════════════════════════════╗
"                ║             » WINDOW MOTIONS «           ║
"                ╚══════════════════════════════════════════╝
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <silent> wq ZZ
nnoremap <silent> q :bp\|bd #<CR>
nnoremap <silent> sq :only<CR>
nnoremap <silent> gl :pc<CR>
"                ╔══════════════════════════════════════════╗
"                ║             » BUFFER SWITCHING «         ║
"                ╚══════════════════════════════════════════╝

nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
"                ╔══════════════════════════════════════════╗
"                ║                 » MACROS «               ║
"                ╚══════════════════════════════════════════╝
nnoremap mm q
"                ╔══════════════════════════════════════════╗
"                ║               » EASY SPLITS «            ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent> sp :vsplit<CR>
nnoremap <silent> sv :split<CR>
"                ╔══════════════════════════════════════════╗
"                ║                » NERDTREE «              ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent><F3> :Lex<CR>
function! NetrwMapping()
    noremap <buffer> N %
endfunction
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END
"                ╔══════════════════════════════════════════╗
"                ║              » SEARCHING «               ║
"                ╚══════════════════════════════════════════╝
nmap S :%s//g<LEFT><LEFT>
vmap S :s//g<LEFT><LEFT>
nnoremap <silent> <Esc> :noh<CR><Esc>
nnoremap <silent> <Leader>sp :Grepper<CR>
nnoremap gab :Grepper-buffers<CR>
nnoremap <silent> <Leader>fr :Far<CR>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>

nnoremap <silent><Leader><Leader> :call Fzf_dev(0)<CR>
nnoremap <silent><Leader>g :GCheckout<CR>
nnoremap <silent><Leader>. :Buffers<CR>
nnoremap <silent><Leader>gl :Commits<CR>
nnoremap <silent><C-O> :call Fzf_dev(1)<CR>
" if g:isWindows
"   nnoremap <silent><Leader><Leader> :DeniteProjectDir -buffer-name=files -direction=dynamicbottom file_rec/git<CR>
"   nnoremap <silent><Leader>g :Denite gitbranch<CR>
"   nnoremap <silent><Leader>. :Denite buffer  -direction=dynamicbottom<CR>
"   nnoremap <silent><Leader>gl :Denite gitlog<CR>
"   nnoremap <silent><C-O> :DeniteProjectDir -buffer-name=files -direction=dynamicbottom file_rec<CR>
" endif

nnoremap <silent><Leader>, :Denite file_mru  -direction=dynamicbottom<CR>
nnoremap <silent><Leader>F :Denite outline  -direction=dynamicbottom<CR>
nnoremap <silent><Leader>m :Denite mark  -direction=dynamicbottom<CR>
xnoremap <silent><Leader>v :<C-u>Denite register -buffer-name=register -default-action=replace<CR>
nmap <leader>a :DeniteProjectDir -buffer-name=grep grep:::!<CR>

call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('normal', 'a', '<denite:do_action:add>', 'noremap')
call denite#custom#map('normal','d','<denite:do_action:delete>','noremap')
call denite#custom#map('normal','r','<denite:do_action:reset>','noremap')
call denite#custom#map('normal','c','<denite:do_action:checkout>','noremap')
"                ╔══════════════════════════════════════════╗
"                ║           » ALE JUMP TO ERRORS «         ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent> <Leader>jj :ALENext<CR>
nnoremap <silent> <Leader>kk :ALEPrevious<CR>
"                ╔══════════════════════════════════════════╗
"                ║          » BLOCK MANIPULATION «          ║
"                ╚══════════════════════════════════════════╝
vmap <up>    <Plug>SchleppUp
vmap <down>  <Plug>SchleppDown
vmap <left>  <Plug>SchleppLeft
vmap <right> <Plug>SchleppRight

"                ╔══════════════════════════════════════════╗
"                ║               » COMPLETION «             ║
"                ╚══════════════════════════════════════════╝
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
"                ╔══════════════════════════════════════════╗
"                ║             » SPELL CHECK «              ║
"                ╚══════════════════════════════════════════╝
nnoremap <silent><F7> :setlocal spell! spell?<CR>
"                ╔══════════════════════════════════════════╗
"                ║                 » MISC «                 ║
"                ╚══════════════════════════════════════════╝
nnoremap ; :
nnoremap <Leader>; ;
set wildchar=<Tab>
function! OpenTerminalDrawer() abort
  execute ':copen'
  execute ':term'
endfunction
nnoremap <silent><Leader>d :call OpenTerminalDrawer()<CR>
nmap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nmap <F5> :so $MYVIMRC<CR>
