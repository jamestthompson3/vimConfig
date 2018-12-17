scriptencoding = utf-8
"                ╔══════════════════════════════════════════╗
"                ║         » Leader AND QUICK ESCAPE «      ║
"                ╚══════════════════════════════════════════╝
let g:mapleader = "\<Space>"
inoremap jj <Esc>

if exists(':tnoremap')
 tnoremap <C-\> <C-\><C-n>
endif


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
nnoremap <silent><F3> :NERDTreeToggle<CR>
nnoremap <silent><Leader>f :NERDTreeFind<CR>
"                ╔══════════════════════════════════════════╗
"                ║              » SEARCHING «               ║
"                ╚══════════════════════════════════════════╝
nmap S :%s//g<LEFT><LEFT>
vmap s :s//g<LEFT><LEFT>
nnoremap <silent> <Esc> :noh<CR><Esc>
nnoremap <silent><Leader>sp :SearchProject<CR>
nnoremap <silent><Leader>gab :SearchBuffers<CR>
nnoremap <silent> <Leader>fr :FindandReplace<CR>
augroup searching
  autocmd BufReadPost quickfix nnoremap <buffer><silent>ra :ReplaceAll<CR>
  autocmd BufReadPost quickfix nnoremap <buffer>rq :ReplaceQF
augroup END

nnoremap <silent><Leader><Leader> :call Fzf_dev(0)<CR>
nnoremap <silent><Leader>a :Rg<CR>
nnoremap <silent><Leader>. :Buffers<CR>

nnoremap <silent><Leader>r :Files <C-r>=expand("%:h")<CR>/<CR>

nnoremap <silent><C-O> :call Fzf_dev(1)<CR>
nnoremap <silent>, :call Fzf_mru()<CR>
nnoremap <silent><Leader>m :Marks<CR>

cnoremap <expr> <CR> CCR()
"                ╔══════════════════════════════════════════╗
"                ║                 » GIT «                  ║
"                ╚══════════════════════════════════════════╝

noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gp :Gpush<CR>
nnoremap <silent><Leader>g :GCheckout<CR>
nnoremap <silent><Leader>gl :Commits<CR>
"
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
"                ╔══════════════════════════════════════════╗
"                ║              » VIM DEV «                 ║
"                ╚══════════════════════════════════════════╝

function! Profiler() abort
  if exists('g:profiler_running')
    profile pause
    unlet g:profiler_running
    noautocmd qall!
  else
    let g:profiler_running = 1
    profile start profile.log
    profile func *
    profile file *
  endif
endfunction
nmap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
nmap <silent><F5> :so $MYVIMRC<CR>
nmap <silent><F7> :so %<CR>
nmap <silent><F1> :call Profiler()<CR>
